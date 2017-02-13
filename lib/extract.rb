module Extract
  autoload :Page, './lib/extract/page'
  autoload :Strategies, './lib/extract/parser'

  class << self
    def run(page)
      Extract::Parser.run(page)
      page
    end
  end
end
