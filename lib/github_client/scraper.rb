require "nokogiri"
require "open-uri"

class GithubClient
  class Scraper < Worker
    def list(path)
      html    = fetch(path)
      entries = parse(html)
      entries = canonicalize(entries, path, nickname)
      sort(entries)
    end

    private

    def fetch(path)
      open("https://github.com/#{nickname}/#{repository}/tree/master/#{path}").read
    end

    def parse(html)
      Parser.parse(html)
    end

    def sort(entries)
      entries.sort_by {|entry| -entry[:time].to_i }
    end

    def canonicalize(entries, path, nickname)
      entries.map do |entry|
        entry[:path]     = "#{path}/#{entry[:path]}"
        entry[:nickname] = nickname
        entry
      end
    end

    class Parser
      attr_reader :html

      def self.parse(*args)
        new(*args).parse
      end

      def initialize(html)
        @html = html
      end

      def parse
        entries.map(&:to_hash)
      end

      def doms
        @doms ||= Nokogiri.HTML(html).css(".tree-browser .tree-entries tr")
      end

      def entries
        doms.map {|dom| Entry.new(dom) }.select(&:valid?)
      end

      class Entry
        def initialize(dom)
          @dom = dom
        end

        def to_hash
          {
            :path      => path,
            :time      => time,
            :persisted => true,
          }
        end

        def path
          @dom.css(".content").text.strip
        end

        def time
          if t = @dom.css(".age time").first
            Time.parse(t.attr("datetime"))
          end
        end

        def valid?
          time && markdown?
        end

        def markdown?
          File.extname(path) == ".md"
        end
      end
    end
  end
end
