module Admin
  module CategoryMatcher
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        property :order
        property :url_matcher

        def category_name
          model.category.name
        end
      end

      class Form < Trailblazer::Cell
        def links
          return ::Link.popular.limit(30) if model.publisher.blank? || model.url_matcher.blank?
          model.publisher.links.find_by_url_regexp(model.url_matcher).recent.limit(30)
        end
      end
    end
  end
end
