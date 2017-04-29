module Admin
  module Story
    module Cell
      class FormLinks < Trailblazer::Cell
        def links
          @options[:links]
        end

        def story_id
          @options[:story_id]
        end
      end

      class FormLink < Trailblazer::Cell
        property :id
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
          label = model.story.try(:id) == @options[:story_id] ? 'remove' : 'add'
          link_to label, '#', class: 'story-form-link-button'
        end
      end
    end
  end
end
