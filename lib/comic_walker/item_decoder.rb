require 'RMagick'
require 'comic_walker/item_decoder/unknown'

module ComicWalker
  class ItemDecoder
    attr_reader :pages

    def initialize(configuration_pack)
      @pages = []
      configuration_pack['configuration']['contents'].each do |content|
        pages[content['index']-1] = content['file']
      end
      @file_info = {}
      @pages.each do |file|
        @file_info[file] = configuration_pack[file]
      end
    end

    def decode(file, dat_path, img_path, blob)
      src = Magick::Image.from_blob(blob).first
      width = src.columns
      height = src.rows
      page_info = @file_info[file]['FileLinkInfo']['PageLinkInfoList'].first['Page']
      dummy_height = page_info['DummyHeight']
      dummy_width = page_info['DummyWidth']
      t = dat_path.sub_ext('').to_s.chars.inject(0) { |acc, c| acc + c.ord }
      pat = t%4 + 1
      moves = Unknown.calculate_moves(width, height, 64, 64, pat)

      dst = Magick::Image.new(width - dummy_width, height - dummy_height)
      dst.format = 'jpeg'
      moves.each do |move|
        crop = src.excerpt(move[:destX], move[:destY], move[:width], move[:height])
        dst.composite!(crop, move[:srcX], move[:srcY], Magick::SrcOverCompositeOp)
      end
      dst.write(img_path.to_s)
    end
  end
end
