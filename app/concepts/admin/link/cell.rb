module Admin
  module Link
    module Cell
      class Index < Trailblazer::Cell
      end

      class Uncategorized < Trailblazer::Cell
        def all_publishers
          grouped_options_for_select(all_publishers_options, params[:publisher_slug])
        end

        private

        def publisher_option(publisher)
          uncategorized_links = number_with_delimiter(publisher.links.uncategorized.size)
          ["#{ publisher.name } (#{ uncategorized_links })", publisher.slug]
        end

        def all_publishers_options
          with_stories = []
          without_stories = []

          ::Publisher.order_by_name.each do |publisher|
            option = publisher_option(publisher)
            publisher.stories.exists? ? with_stories.push(option) : without_stories.push(option)
          end

          [['With Stories', with_stories], ['Without Stories', without_stories]]
        end
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
          return 'None' if model.story.blank?
          model.story.id
        end

        def social_counters
          return if model.social_counters.blank?
          concept(
            'admin/link/cell/social_counter',
            collection: model.social_counters.recent.limit(5)
          )
        end
      end

      class UncategorizedItem < Trailblazer::Cell
        property :url

        def publisher_name
          model.publisher.name
        end

        def total_social
          number_with_delimiter(model.total_social)
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
