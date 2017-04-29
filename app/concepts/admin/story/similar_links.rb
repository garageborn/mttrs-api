module Admin
  module Story
    module Cell
      class SimilarLinks < Trailblazer::Cell
        def links
          @options[:links]
        end

        def story_id
          params[:id].to_i
        end
      end

      class SimilarLink < Trailblazer::Cell
        delegate :record, to: :model
        delegate :id, :title, :url, to: :record

        def category_name
          record.category.name
        end

        def publisher_name
          record.publisher.name
        end

        def image
          return if record.image_source_url.blank?
          image_tag(record.image_source_url, size: '75x75')
        end

        def total_social
          number_with_delimiter(record.total_social)
        end

        def score
          number_with_precision(model.score, precision: 2)
        end

        def publisher_name
          record.publisher.name
        end

        def category_name
          record.category.try(:name)
        end

        def published_at
          localize(record.published_at, format: :short)
        end

        def story_id
          return if record.story.blank?
          link_to(record.story.id, [:edit, :admin, record.story], class: 'links-edit-button')
        end

        def actions
          label = record.story.try(:id) == @options[:story_id] ? 'remove' : 'add'
          link_to label, '#', class: 'story-form-link-button'
        end
      end
    end
  end
end
