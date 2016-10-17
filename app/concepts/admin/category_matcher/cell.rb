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
        def matching_links
          publisher = ::Publisher.find_by(id: model.publisher_id)
          return if publisher.blank? || model.url_matcher.blank?
          publisher.links.find_by_url_regexp(model.url_matcher).recent.limit(50)
        end

        def uncategorized_links
          publisher = ::Publisher.find_by(id: model.publisher_id)
          return ::Link.uncategorized.popular.limit(50) if publisher.blank?
          publisher.links.uncategorized.popular.limit(50)
        end
      end
    end
  end
end
