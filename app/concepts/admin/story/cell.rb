module Admin
  module Story
    module Cell
      class Index < Trailblazer::Cell
        def next_day_link
          day_link(next_day)
        end

        def prev_day_link
          day_link(prev_day)
        end

        def current_day_link
          day_link(current_day)
        end

        def categories_links
          top_stories = category_link(OpenStruct.new(name: 'Top Stories'))
          categories = ::Category.ordered.map { |category| category_link(category) }
          [top_stories] + categories
        end

        private

        def prev_day
          current_day - 1.day
        end

        def next_day
          current_day + 1.day
        end

        def day_link(day)
          link_to(
            day,
            admin_stories_path(story_params.merge(published_at: day)),
            class: 'stories-add-button'
          )
        end

        def current_day
          return Date.parse(story_params[:published_at]) if story_params[:published_at].present?
          Time.zone.today
        end

        def category_link(category)
          link_to(
            category.name,
            admin_stories_path(story_params.merge(category_slug: category.slug)),
            class: 'stories-add-button'
          )
        end

        def story_params
          params.permit(:published_at, :category_slug)
        end
      end

      class Item < Trailblazer::Cell
        property :main_link

        def other_links
          model.other_links.popular
        end
      end

      class Link < Trailblazer::Cell
        property :title
        property :url
        property :story

        def class_name
          options[:class_name]
        end

        def image
          return if model.image_source_url.blank?
          image_tag(model.image_source_url, size: '100x100')
        end

        def total_social
          number_with_delimiter(model.total_social)
        end

        def publisher_name
          model.publisher.name
        end

        def category_name
          model.category.try(:name)
        end

        def published_at
          localize(model.published_at, format: :short)
        end
      end

      class Form < Trailblazer::Cell
        property :links

        def similar
          similar_links = SimilarLinks.new(model.main_link)

          model.links.each do |link|
            link.similar(min_score: 1).each do |similar_link|
              next if model.link_ids.include?(similar_link.id)
              similar_links.add(similar_link.record, similar_link.hit)
            end
          end

          similar_links
        end
      end

      class FormLink < Trailblazer::Cell
        property :title
        property :url

        def category_name
          model.category.name
        end

        def publisher_name
          model.publisher.name
        end

        def image
          return if model.image_source_url.blank?
          image_tag(model.image_source_url, size: '75x75')
        end

        def total_social
          number_with_delimiter(model.total_social)
        end

        def score
          return unless model.respond_to?(:score)
          number_with_delimiter(model.score)
        end

        def publisher_name
          model.publisher.name
        end

        def category_name
          model.category.try(:name)
        end

        def published_at
          localize(model.published_at, format: :short)
        end

        def story_id
          return if model.story.blank?
          link_to(model.story.id, [:edit, :admin, model.story], class: 'links-edit-button')
        end

        def actions
          return 'add' if model.story.blank?
          model.story.id == @options[:story].id ? 'remove' : 'merge'
        end
      end
    end
  end
end
