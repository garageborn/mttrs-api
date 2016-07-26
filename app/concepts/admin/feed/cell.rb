module Admin
  module Feed
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Show < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper
        property :url

        def links_count
          number_with_delimiter(model.links.size)
        end
      end

      class Form < Trailblazer::Cell
        include ActionView::Helpers::FormOptionsHelper
      end
    end
  end
end
