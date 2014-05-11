require 'json'
require 'pathname'
require 'pp'
require 'thor'
require 'yaml'
require 'comic_walker/client'
require 'comic_walker/content_downloader'
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
        ContentDownloader.new(client, cid).save
      end
    end

    desc 'save-all CID1 CID2...', 'Save all sub-contents'
    def save_all(*parent_cids)
      jar = HTTP::CookieJar.new
      load_cookies(jar)
      child_cids = find_sub_contents(V1::Client.new(jar, load_uuid), parent_cids)
      save_cookies(jar)
      save(*child_cids)
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

      json['contents'].sort_by { |content| Time.parse(content['updated_at']) }.reverse_each do |content|
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

    def find_sub_contents(client, parent_cids)
      page = 1
      per_page = 200
      child_cids = {}
      client.start do
        until child_cids.size == parent_cids do
          json = client.contents(page: page, per_page: per_page)
          contents = json['contents']
          if contents.empty?
            break
          end
          contents.each do |c|
            if parent_cids.include?(c['content_id'])
              child_cids[c['content_id']] = c['sub_contents']
            end
          end
          page += 1
        end
      end
      parent_cids.each do |cid|
        unless child_cids.has_key?(cid)
          $stderr.puts "No such content: #{cid}"
        end
      end
      child_cids.values.flatten
    end
  end
end
