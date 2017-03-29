module Admin
  module TagMatcher
    module Cell
      class Index < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        property :name

        def tag_name
          model.tag.name
        end

        def category_name
          model.category.name
        end
      end

      class Form < Trailblazer::Cell
        def tags_collection
          ::Category.order_by_name.map do |category|
            next if category.tags.blank?
            category.tags.order_by_name.map do |tag|
              ["#{ category.name }/#{ tag.name }", tag.id]
            end.flatten
          end.compact.uniq
        end
      end
    end
  end
end
