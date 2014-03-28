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
        items = {}
        decoder = nil
        while entry = zip.get_next_entry
          case entry.name
          when 'configuration_pack.json'
            decoder = ItemDecoder.new(JSON.parse(zip.read))
          when %r{\Aitem/}
            items[entry.name] = zip.read
          end
        end

        img_dir = Pathname.new(title).join(cid).tap(&:mkpath)
        items.each do |dat_path, data|
          dat_path = Pathname.new(dat_path)
          img_path = img_dir.join(dat_path.parent.basename.sub_ext('.jpg'))
          puts "#{dat_path} -> #{img_path}"
          decoder.decode(dat_path, img_path, data)
        end
      end
    end
  end
end
