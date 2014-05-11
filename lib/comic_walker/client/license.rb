require 'addressable/uri'
require 'base64'
require 'net/http'

module ComicWalker
  class Client
    class License
      def initialize(json)
        @json = json
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

      def get_configuration_pack
        uri = Addressable::URI.parse(url_prefix + 'configuration_pack.json')
        Net::HTTP.start(uri.host) do |http|
          JSON.parse(http.get(uri.request_uri).body)
        end
      end

      def get_info
        uri = Addressable::URI.parse(info_url)
        body = Net::HTTP.start(uri.host) do |http|
          http.get(uri.request_uri).body
        end
        JSON.parse(body)
      end

      def get_jpeg(file)
        uri = Addressable::URI.parse(url_prefix + file + '/0.jpeg')
        Net::HTTP.start(uri.host) do |http|
          http.get(uri.request_uri).body
        end
      end
    end
  end
end
