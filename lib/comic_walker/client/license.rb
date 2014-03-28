require 'addressable/uri'
require 'base64'
require 'net/http'
require 'zip'

module ComicWalker
  class Client
    class License
      def initialize(json)
        @json = json
      end

      def agreement
        @json['agreement']
      end

      def jar_url
        agreement['url_prefix'] + agreement['jar_file_name']
      end

      def info_url
        agreement['url_prefix'] + agreement['info_file_name']
      end

      def key
        Base64.decode64(agreement['key']).unpack('C*')
      end

      def with_jar(&block)
        uri = Addressable::URI.parse(jar_url)
        body = Net::HTTP.start(uri.host) do |http|
          http.get(uri.request_uri).body
        end
        Zip::InputStream.open(StringIO.new(body), &block)
      end

      def get_info
        uri = Addressable::URI.parse(info_url)
        body = Net::HTTP.start(uri.host) do |http|
          http.get(uri.request_uri).body
        end
        JSON.parse(body)
      end
    end
  end
end
