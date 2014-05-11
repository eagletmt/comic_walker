module ComicWalker
  class ContentDownloader
    def initialize(client, cid)
      @client = client
      @cid = cid
    end

    def save
      license = @client.get_license(@cid)
      info = license.get_info.first
      last_update = Time.strptime(info['last_update'], '%Y%m%d%H%M')
      title = info['issues'].first['content_name']

      license.with_jar do |zip|
        pages = []
        items = {}
        decoder = nil
        while entry = zip.get_next_entry
          case entry.name
          when 'configuration_pack.json'
            config = JSON.parse(zip.read)
            decoder = ItemDecoder.new(config)
          when /end_layer\.json/
            begin
              pp EndLayerDecoder.new(license.key).decode(zip.read)
            rescue JSON::ParserError
              $stderr.puts "WARNING: #{@cid}: Could not decode end_layer.json.enc"
            end
          when %r{\Aitem/}
            items[entry.name] = zip.read
          end
        end

        img_dir = Pathname.new(title).join(@cid).tap(&:mkpath)
        decoder.pages.each.with_index do |file, i|
          dat_path = Pathname.new(file).join('0.dat')
          img_fname = dat_path.parent.basename.sub_ext('.jpg')
          img_path = img_dir.join(sprintf('%03d_%s', i, img_fname))

          if data = items[dat_path.to_s]
            decoder.decode_b64(file, dat_path, img_path, data)
          else
            decoder.decode(file, dat_path, img_path, license.get_jpeg(file))
          end
          puts "#{dat_path} -> #{img_path}"
        end
      end
    end
  end
end
