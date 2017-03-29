module Admin
  module Tag
    module Cell
      class Index < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        property :name
        property :order

        def category_name
          model.category.name
        end

        def links_count
          # number_with_delimiter(model.links.size)
        end

        def stories_count
          # number_with_delimiter(model.stories.size)
        end
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
