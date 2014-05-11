module ComicWalker
  class ContentDownloader
    def initialize(client, cid)
      @client = client
      @cid = cid
    end

    def save
      license = @client.get_license(@cid)
      decoder = ItemDecoder.new(license.get_configuration_pack)
      img_dir = image_dir(license)
      decoder.pages.each.with_index do |file, i|
        dat_path = Pathname.new(file).join('0.dat')
        img_fname = dat_path.parent.basename.sub_ext('.jpg')
        img_path = img_dir.join(sprintf('%03d_%s', i, img_fname))
        decoder.decode(file, dat_path, img_path, license.get_jpeg(file))
        puts "#{dat_path} -> #{img_path}"
      end
    end

    def image_dir(license)
      info = license.get_info.first
      title = info['issues'].first['content_name']
      Pathname.new(title).join(@cid).tap(&:mkpath)
    end
  end
end
