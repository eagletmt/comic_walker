require 'uri'
require 'base64'
require 'net/http/persistent'

module ComicWalker
  class Client
    class License
      def initialize(json)
        @json = json
        @http = Net::HTTP::Persistent.new('comic_walker')
      end

      def agreement
        @json['agreement']
      end

      def info_url
        url_prefix + agreement['info_file_name']
      end

      def url_prefix
        agreement['url_prefix']
      end

      CONFIGURATION_PACK_FILENAME = 'configuration_pack.json'

      def configuration_pack_url
        url_prefix + CONFIGURATION_PACK_FILENAME
      end

      def get(url)
        @http.request(URI.parse(url))
      end

      def get_configuration_pack
        JSON.parse(get(configuration_pack_url).body)
      end

      def get_info
        JSON.parse(get(info_url).body)
      end

      def get_jpeg(file)
        get(url_prefix + file + '/0.jpeg').body
      end
    end
  end
end
