module Seeds
  class CategoryMatcher
    extend Memoist
    attr_reader :publisher_name, :categories

    def initialize(publisher_name, categories)
      @publisher_name = publisher_name
      @categories = categories
    end

    def run!
      return if publisher.blank?
      publisher.category_matchers.replace(category_matchers)
      publisher.links.each { |link| LinkAssignerJob.perform_async(link.id) }
    end

    def test
      logger << "\n"
      logger.info "## #{ publisher.name }"
      category_matchers.each do |category_matcher|
        links = publisher.links.select do |link|
          LinkCategorizer::Matcher.new(category_matcher, link).match?
        end

        logger << "\n"
        logger.info "#{ category_matcher.category.name }: #{ category_matcher.url_matcher }"
        logger.info "matching: #{ links.size }/#{ publisher.links.size }"

        links.each { |link| logger.info link.url }
      end
    end

    def self.run!
      data = JSON.parse(File.open("#{ Rails.root }/lib/seeds/data/category_matchers.json").read)
      data.each do |publisher_name, categories|
        category_matcher = new(publisher_name, categories)
        category_matcher.run!
        category_matcher.test
      end
    end

    private

    def publisher
      Publisher.find_by_name(publisher_name)
    end

    def category_matchers
      categories.map do |category_name, url_matchers|
        [url_matchers].flatten.map do |url_matcher|
          build_category_matcher(category_name, url_matcher)
        end
      end.flatten.compact.uniq
    end

    def build_category_matcher(category_name, url_matcher)
      Category.find_by_name(category_name).category_matchers.
        where(url_matcher: url_matcher).first_or_initialize
    end

    def logger
      Logger.new(STDOUT)
    end

    memoize :publisher, :category_matchers, :logger
  end
end
