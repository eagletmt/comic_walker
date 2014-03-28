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

    def get_license(cid)
      u1 = get_u1(cid)
      json = get_li(cid, u1)
      license_b64 = json['license']
      License.new(JSON.parse(Cipher.decrypt_license(@bid, u1, license_b64)))
    end

    def get_u1(cid)
      uri = Addressable::URI.parse("http://comic-walker.com/viewer/?cid=#{cid}")
      Net::HTTP.start(uri.host, 80) do |http|
        res = http.get(uri.request_uri)
        Addressable::URI.unescape(HTTP::Cookie.cookie_value_to_hash(res['set-cookie'])['u1'])
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
