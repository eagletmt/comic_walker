require 'json'
require 'comic_walker/client/unknown'

module ComicWalker
  class EndLayerDecoder
    def initialize(key)
      @key = key
    end

    def decode(b64)
      JSON.parse(Client::Unknown.dea0qData_(@key, b64))
    end
  end
end
