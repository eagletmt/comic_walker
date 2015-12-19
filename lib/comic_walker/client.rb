require 'addressable/uri'
require 'http-cookie'
require 'json'
require 'net/http'
require 'comic_walker/cipher'
require 'comic_walker/client/license'

module ComicWalker
  class Client
    def initialize
      @bid = '000000000000000000000NFBR'
    end

    class Error < StandardError
      attr_reader :code, :reason
      def initialize(code, reason)
        super("#{code}: #{reason}")
        @code = code
        @reason = reason
      end
    end

    def get_license(cid)
      u1 = get_u1(cid)
      json = get_li(cid, u1)
      if error = json['error']
        raise Error.new(error['code'], error['message'])
      end
      license_b64 = json['license']
      License.new(JSON.parse(Cipher.decrypt_license(@bid, u1, license_b64)))
    end

    def get_u1(cid)
      uri = Addressable::URI.parse("http://comic-walker.com/viewer/?tw=2&dlcl=ja&cid=#{cid}")
      Net::HTTP.start(uri.host, 80) do |http|
        res = http.get(uri.request_uri)
        if set_cookie = res['set-cookie']
          u1 = HTTP::Cookie.cookie_value_to_hash(set_cookie)['u1']
          if u1
            Addressable::URI.unescape(u1)
          end
        end
      end
    end

    def get_li(cid, u1)
      uri = Addressable::URI.parse("https://cnts.comic-walker.com/api4js/v1/c/#{cid}/li")
      uri.query_values = {
        'BID' => @bid,
        'AID' => 'browser',
        'AVER' => '1.2.0',
        'S' => u1,
        'FORMATS' => 'epub_brws,epub_brws_fixedlayout,epub_brws_omf',
        'W' => 720,
        'H' => 1280,
      }

      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      body = https.start do
        req = Net::HTTP::Get.new(uri.request_uri)
        res = https.request(req)
        res.body
      end
      JSON.parse(body)
    end
  end
end
