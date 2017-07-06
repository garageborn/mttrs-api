module Admin
  module Category
    module Cell
      class Index < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        property :id
        property :name
        property :order

        def links_count
          number_with_delimiter(model.links.size)
        end

        def stories_count
          number_with_delimiter(model.stories.size)
        end
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
