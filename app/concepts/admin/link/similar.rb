module Admin
  module Link
    module Cell
      class Similar < Trailblazer::Cell
      end

      class SimilarItem < Trailblazer::Cell
        property :title

        def published_at
          localize(model.published_at, format: :short)
        end

        def score
          number_with_precision(model.score, precision: 2)
        end
      end
    end
  end
end
