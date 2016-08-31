module Admin
  module Namespace
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        property :slug

        def links_count
          number_with_delimiter(model.links.size)
        end

        def feeds_count
          number_with_delimiter(model.feeds.size)
        end

        def categories_count
          number_with_delimiter(model.categories.size)
        end
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
