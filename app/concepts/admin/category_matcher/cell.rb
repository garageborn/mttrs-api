module Admin
  module CategoryMatcher
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper
        property :order
        property :url_matcher
      end

      class Form < Trailblazer::Cell
        include ActionView::Helpers::FormOptionsHelper
      end
    end
  end
end
