require 'addressable/uri'
require 'http-cookie'
require 'json'
require 'net/http/persistent'
require 'retryable'
require 'uri'

module ComicWalker
  module V1
    class Client
      BASE_URI = Addressable::URI.parse("https://cnts.comic-walker.com")

      def initialize(jar, uuid)
        @https = Net::HTTP::Persistent.new('comic_walker')
        @jar = jar
        @uuid = uuid
      end

      AID = 'KDCWI_JP'
      AVER = '1.2.0'

      class UnknownDeviceError < StandardError
      end
      class NoValidSessionError < StandardError
      end

      def create_session
        on_exception = lambda { |exception| create_user }
        retryable(tries: 2, on: UnknownDeviceError, sleep: 0, exception_cb: on_exception) do
          res = post('/user_sessions/create', {
            DID: @uuid,
            PIN: @uuid,
            AID: AID,
            AVER: AVER,
          })
          case res.body
          when 'UnknownDeviceError'
            raise UnknownDeviceError.new
          when 'ValidSessionExistsError'
            nil
          else
            JSON.parse(res.body)
          end
        end
      end

      def create_user
        post('/users/create', {
          DID: @uuid,
          PIN: @uuid,
          AID: AID,
          AVER: AVER,
        })
      end

      def contents(params = {})
        params = {
          AID: AID,
          AVER: AVER,
          W: '320',
          H: '480',
          FORMATS: 'epub_pdf_fixedlayout',
          include_hidden: 1,
          include_meta: 1,
          languages: 'ja',
        }.merge(params)

        on_exception = lambda { |exception| create_session }
        retryable(tries: 2, on: NoValidSessionError, sleep: 0, exception_cb: on_exception) do
          res = get('/v1/contents', params)
          case res.body
          when 'NoValidSessionError'
            raise NoValidSessionError.new
          else
            JSON.parse(res.body)
          end
        end
      end

      private

      def get(path, params = {})
        uri = BASE_URI.join(path)
        uri.query_values = params
        req = Net::HTTP::Get.new(uri.request_uri)
        request_with_cookie(uri, req)
      end

      def post(path, params = {})
        uri = BASE_URI.join(path)
        req = Net::HTTP::Post.new(uri.request_uri)
        req.set_form_data(params)
        request_with_cookie(uri, req)
      end

      def request_with_cookie(uri, req)
        req['cookie'] = HTTP::Cookie.cookie_value(@jar.cookies(uri.to_s))
        @https.request(URI.parse(uri.to_s), req).tap do |res|
          @jar.parse(res['set-cookie'], uri.to_s)
        end
      end
    end
  end
end
