module Admin
  module Link
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        property :title

        def published_at
          localize(model.published_at)
        end

        def categories_names
          model.categories.pluck(:name).to_sentence
        end

        def publisher_name
          model.publisher.name
        end

        def story_id
          return 'None' if model.story_id.blank?
          model.story_id
        end

        def social_counters
          return if model.social_counters.blank?
          concept(
            'admin/link/cell/social_counter',
            collection: model.social_counters.recent.limit(5)
          )
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
      end
    end
  end
end
