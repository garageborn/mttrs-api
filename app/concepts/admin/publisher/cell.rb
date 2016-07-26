module Admin
  module Publisher
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper

        property :name
        property :domain

        def links_count
          number_with_delimiter(model.links.size)
        end

        def feeds_count
          number_with_delimiter(model.feeds.size)
        end
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
