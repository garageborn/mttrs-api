module Extract
  autoload :Page, './lib/extract/page'
  autoload :Strategies, './lib/extract/strategies'

  class << self
    def run(page)
      available_strategies(page).each do |strategy|
        strategy.run(page)
        break if page.complete?
      end
      page
    end

    private

    def strategies
      Extract::Strategies.ordered
    end

    def available_strategies(page)
      strategies.select do |strategy|
        strategy::AVAILABLE_ATTRIBUTES.any? { |attr| page.missing_attributes.include?(attr) }
      end
    end
  end
end
