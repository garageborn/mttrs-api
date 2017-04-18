module Admin
  module Link
    module Cell
      class Index < Trailblazer::Cell
        def publishers_select
          publishers = ::Publisher.available_on_current_tenant.order_by_name.distinct
          options = options_from_collection_for_select(
            publishers,
            :slug,
            :name,
            params[:publisher_slug],
          )
          select_tag('links_publisher_slug', options, prompt: 'Publishers')
        end

        def tags_select
          collection = ::Category.order_by_name.map do |category|
            next if category.tags.blank?
            tags = category.tags.order_by_name.map { |r| [r.name, r.slug] }
            [category.name, tags]
          end.compact.uniq

          grouped_options = grouped_options_for_select(collection, params[:tag_slug])
          select_tag('links_tag_slug', grouped_options, prompt: 'Tags')
        end
      end

      class Uncategorized < Trailblazer::Cell
        def total
          number_with_delimiter(model.distinct.total_count)
        end
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

        def category_name
          model.category.try(:name)
        end

        def publisher_name
          model.publisher.name
        end

        def tags
          model.tags.pluck(:name).sort.to_sentence
        end

        def story_id
          return if model.story.blank?
          link_to model.story.id, [:edit, :admin, model.story]
        end

        def total_social
          number_with_delimiter(model.total_social)
        end

        def image
          return if model.image_source_url.blank?
          image_tag(model.image_source_url, size: '100x100')
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
          localize(model.published_at, format: :short)
        end

        def score
          number_with_precision(model.score, precision: 2)
        end
      end

      class BlockedLinks < Trailblazer::Cell
        INCLUDES = %i(category publisher story link_url).freeze

        def blocked_links
          model.blocked_links.popular.includes(INCLUDES)
        end
      end

      class BlockedLink < Trailblazer::Cell
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
      end

      class Form < Trailblazer::Cell
        property :story
        property :similar

        def html
          return unless model.html.valid_encoding?
          model.html
        end
      end
    end
  end
end
