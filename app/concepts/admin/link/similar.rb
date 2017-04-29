module Admin
  module Link
    module Cell
      class Similar < Trailblazer::Cell
      end

      class SimilarItem < Trailblazer::Cell
        def published_at
          localize(model.record.published_at, format: :short)
        end

        def score
          number_with_precision(model.score, precision: 2)
        end

        def title
          model.record.title
        end
      end
    end
  end
end
