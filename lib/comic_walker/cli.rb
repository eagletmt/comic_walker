require 'json'
require 'pathname'
require 'pp'
require 'thor'
require 'yaml'
require 'comic_walker/client'
require 'comic_walker/end_layer_decoder'
require 'comic_walker/item_decoder'
require 'comic_walker/v1/client'

module ComicWalker
  class CLI < Thor
    package_name 'comic_walker'

    CONFIG_DIR = Pathname.new(ENV['HOME']).join('.comic-walker')
    CONFIG_PATH = CONFIG_DIR.join('config.yml')
    COOKIE_PATH = CONFIG_DIR.join('cookie.yml')

    desc 'save CID1 CID2...', 'Save contents'
    def save(*cids)
      client = Client.new
      cids.each do |cid|
        save_content(client, cid)
      end
    end

    desc 'contents', 'List contents'
    option :page,
      desc: 'Page',
      aliases: :p,
      type: :numeric
    option :per_page,
      desc: 'Per page',
      type: :numeric
    def contents
      jar = HTTP::CookieJar.new
      load_cookies(jar)
      client = V1::Client.new(jar, load_uuid)
      json = client.start do
        client.contents(per_page: options[:per_page], page: options[:page])
      end
      save_cookies(jar)

      json['contents'].each do |content|
        next unless content.has_key?('sub_contents')
        puts "#{content['name']} http://comic-walker.com/contents/detail/#{content['content_id']}"
        puts "  Updated: #{format_time(content['updated_at'])}"
        puts "  Deliver: #{format_time(content['deliver_start_date'])} - #{format_time(content['deliver_stop_date'])}"
        tags = content['tags']
        puts "  Episodes:"
        tags['visible_episodes'].each_key do |episode|
          _, desc, cid = *episode.split('|')
          puts "    #{desc} http://comic-walker.com/viewer/?cid=#{cid}"
        end
        if next_issue = tags['publication_date_of_next_issue']
          next_issue = format_time(next_issue.keys.first)
        else
          next_issue = 'UNKNOWN'
        end
        puts "  Next: #{next_issue}"
      end
    end

    private

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
          when /end_layer\.json/
            pp EndLayerDecoder.new(license.key).decode(zip.read)
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

    def load_cookies(jar)
      if COOKIE_PATH.readable?
        jar.load(COOKIE_PATH.to_s, session: true)
      end
    end

    def save_cookies(jar)
      CONFIG_DIR.mkpath
      jar.save(COOKIE_PATH.to_s, session: true)
    end

    def load_uuid
      CONFIG_DIR.mkpath
      yaml = CONFIG_PATH.readable? && YAML.load_file(CONFIG_PATH.to_s)
      uuid = yaml && yaml['uuid']
      unless uuid
        require 'securerandom'
        uuid = SecureRandom.uuid.upcase
        CONFIG_PATH.open('w') do |f|
          YAML.dump({uuid: uuid}, f)
        end
      end
      uuid
    end

    def format_time(str)
      Time.parse(str).strftime('%F %X')
    end
  end
end
