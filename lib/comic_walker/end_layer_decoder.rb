require 'json'
require 'comic_walker/cipher'

module ComicWalker
  class EndLayerDecoder
    def initialize(key)
      @key = key
    end

    def decode(b64)
      JSON.parse(Client::Cipher.decrypt_b64(@key, b64))
    end
  end
end
