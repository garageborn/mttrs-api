module Extract
  autoload :Page, './lib/extract/page'
  autoload :Strategies, './lib/extract/strategies'

  class << self
    def run(url, options = {})
      Extract::Page.new.tap do |page|
        strategies.each do |strategy|
          current_page = strategy.run(url, options)
          next if current_page.blank?
          page.merge(current_page)
          break if page.complete?
        end
      end
    end

    private

    def strategies
      Extract::Strategies.ordered
    end
  end
end
