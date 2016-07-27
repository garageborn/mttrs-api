module Admin
  module Publisher
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper

        property :id
        property :name
        property :domain

        def links_count
          number_with_delimiter(model.links.size)
        end

        def today_links_count
          number_with_delimiter(model.links.today.size)
        end

        def feeds_count
          number_with_delimiter(model.feeds.size)
        end

        def feeds
          model.feeds.group_by(&:publisher)
        end

        def feeds_count
          number_with_delimiter(model.feeds.size)
        end

        def category_matchers
          model.category_matchers.group_by(&:category)
        end

        def category_matchers_count
          number_with_delimiter(model.category_matchers.size)
        end
      end

      class Feed < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper
        property :url

        def links_count
          number_with_delimiter(model.links.size)
        end
      end

      class CategoryMatcher < Trailblazer::Cell
        property :order
        property :url_matcher
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
