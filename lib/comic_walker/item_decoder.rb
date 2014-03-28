require 'RMagick'
require 'comic_walker/item_decoder/unknown'

module ComicWalker
  class ItemDecoder
    def initialize(configuration_pack)
      fname = '0.dat'
      ct = configuration_pack['ct']
      st = configuration_pack['st']
      et = configuration_pack['et']
      @key1 = ct + st + fname
      @key2 = ct + fname + et
      @key3 = fname + st + et
    end

    def decode(dat_path, img_path, data)
      bs = 128
      hs = 1024
      chunks = Unknown.decrypt(Unknown.split_encrypted_data(data, @key3), @key1, @key2, bs, hs)
      blob = chunks.map { |x| x.pack('C*') }.join('')

      src = Magick::Image.from_blob(blob).first
      width = src.columns
      height = src.rows
      t = dat_path.sub_ext('').to_s.chars.inject(0) { |acc, c| acc + c.ord }
      pat = t%4 + 1
      moves = Unknown.calculate_moves(width, height, 64, 64, pat)

      dst = Magick::Image.new(width, height)
      dst.format = 'jpeg'
      moves.each do |move|
        crop = src.excerpt(move[:destX], move[:destY], move[:width], move[:height])
        dst.composite!(crop, move[:srcX], move[:srcY], Magick::SrcOverCompositeOp)
      end
      dst.write(img_path.to_s)
    end
  end
end
