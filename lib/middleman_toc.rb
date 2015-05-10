require 'middleman'
require 'yaml'
require 'middleman_toc/extension'
require 'middleman_toc/toc'
require 'middleman_toc/validator'

module MiddlemanToc
  class << self
    def instance(sitemap)
      @instance ||= Toc.new(pages(sitemap)).tap do |toc|
        Validator.new(toc.pages, toc.root).validate!
      end
    end

    def toc(sitemap, path)
      rendering { instance(sitemap).toc(path) } # .tap { |html| puts html }
    end

    def prev_page(sitemap, path)
      rendering { instance(sitemap).prev_page(path) }
    end

    def next_page(sitemap, path)
      rendering { instance(sitemap).next_page(path) }
    end

    def pages(sitemap)
      sitemap.resources.inject({}) do |pages, page|
        pages.merge(page.path.gsub(%r((^|\/)[\d]+\-), '').sub('.html', '\1') => page)
      end
    end

    def rendering
      return if @rendering
      @rendering = true
      yield.tap { @rendering = false }
    end
  end
end

Middleman::Extensions.register(:toc, MiddlemanToc::Extension)
