module Admin
  module Link
    module Cell
      class Index < Trailblazer::Cell
      end

      class Uncategorized < Trailblazer::Cell
      end

      class Similar < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        def title
          link_to(model.title, model.url, target: :_blank)
        end

        def published_at
          localize(model.published_at, format: :short)
        end

        def categories_names
          model.categories.pluck(:name).to_sentence
        end

        def publisher_name
          model.publisher.name
        end

        def story_id
          return 'None' if model.story.blank?
          link_to model.story.id, [:edit, :admin, model.story]
        end

        def total_social
          number_with_delimiter(model.total_social)
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

      class SimilarItem < Trailblazer::Cell
        property :title

        def published_at
          localize(Time.zone.parse(model.published_at), format: :short)
        end

        def score
          number_with_precision(model._score, precision: 2)
        end
      end

      class SocialCounter < Trailblazer::Cell
        def total
          number_with_delimiter(model.total)
        end

        def facebook
          number_with_delimiter(model.facebook)
        end

        def linkedin
          number_with_delimiter(model.linkedin)
        end

        def twitter
          number_with_delimiter(model.twitter)
        end

        def pinterest
          number_with_delimiter(model.pinterest)
        end

        def google_plus
          number_with_delimiter(model.google_plus)
        end

        def created_at
          localize(model.created_at)
        end
      end

      class Form < Trailblazer::Cell
        property :story

        def html
          model.html.force_encoding('UTF-8')
        end
      end
    end
  end
end
