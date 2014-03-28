require 'json'
require 'pathname'
require 'comic_walker/client'
require 'comic_walker/item_decoder'

module ComicWalker
  class CLI
    def run(cids)
      client = Client.new
      cids.each do |cid|
        save_content(client, cid)
      end
    end

    def save_content(client, cid)
      license = client.get_license(cid)
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
            config['configuration']['contents'].each do |content|
              pages[content['index']-1] = content['file']
            end
          when %r{\Aitem/}
            items[entry.name] = zip.read
          end
        end

        img_dir = Pathname.new(title).join(cid).tap(&:mkpath)
        pages.each.with_index do |file, i|
          dat_path = Pathname.new(file).join('0.dat')
          data = items[dat_path.to_s]
          img_fname = dat_path.parent.basename.sub_ext('.jpg')
          img_path = img_dir.join(sprintf('%03d_%s', i, img_fname))
          puts "#{dat_path} -> #{img_path}"
          decoder.decode(dat_path, img_path, data)
        end
      end
    end
  end
end
