require 'feedjira'
require 'open-uri'
require 'time'

module Jekyll
  class ExternalPostsGenerator < Generator
    safe true
    priority :low

    def generate(site)
      return unless site.config['external_sources']

      site.config['external_sources'].each do |source|
        if source['rss_url']
          fetch_from_rss(site, source['rss_url'], source['name'])
        elsif source['posts']
          fetch_manual_posts(site, source['posts'], source['name'])
        end
      end
    end

    def fetch_from_rss(site, rss_url, source_name)
      puts "Fetching external posts from #{source_name}:"

      begin
        xml = URI.open(rss_url, "User-Agent" => "JekyllRSSFetcher/1.0").read
        feed = Feedjira.parse(xml)

        if feed.respond_to?(:entries)
          feed.entries.each do |entry|
            site.posts.docs << ExternalPost.new(site, entry, source_name)
          end
        else
          puts "⚠ No entries found or incompatible feed format from #{source_name}. Skipping."
        end

      rescue StandardError => e
        puts "⚠ Skipping #{source_name}: #{e.class} - #{e.message}"
      end
    end

    def fetch_manual_posts(site, posts, source_name)
      posts.each do |post|
        site.posts.docs << ExternalPost.new(site, post, source_name, manual: true)
      end
    end
  end

  class ExternalPost < Document
    def initialize(site, raw_data, source_name, manual: false)
      super(site.in_source_dir('_news'), { "read" => false })

      self.data['layout'] = 'post'
      self.data['external'] = true
      self.data['source_name'] = source_name

      if manual
        self.data['title'] = raw_data['title'] || "External Article"
        self.data['url'] = raw_data['url']
        self.data['date'] = Time.parse(raw_data['published_date'])
      else
        self.data['title'] = raw_data.title
        self.data['url'] = raw_data.url
        self.data['date'] = raw_data.published || Time.now
      end
    end
  end
end
