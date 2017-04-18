module Admin
  module Link
    module Cell
      class Uncategorized < Trailblazer::Cell
        def total
          number_with_delimiter(model.distinct.total_count)
        end
      end

      class UncategorizedItem < Trailblazer::Cell
        property :url

        def published_at
          localize(model.published_at, format: :short)
        end

        def publisher_name
          model.publisher.name
        end

        def total_social
          number_with_delimiter(model.total_social)
        end
      end
    end
  end
end
