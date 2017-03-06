module Admin
  module PublisherSuggestion
    module Cell
      class Index < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        property :name

        def count
          number_with_delimiter(model.count)
        end
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
