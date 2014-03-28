require 'json'
require 'comic_walker/client/unknown'

module ComicWalker
  class EndLayerDecoder
    def initialize(key)
      @key = key
    end

    def decode(b64)
      JSON.parse(Client::Unknown.decrypt_b64(@key, b64))
    end
  end
end
