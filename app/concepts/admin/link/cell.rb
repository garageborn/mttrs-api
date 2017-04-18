module Admin
  module Link
    module Cell
      class Index < Trailblazer::Cell
        def publishers_select
          options = options_from_collection_for_select(
            ::Publisher.available_on_current_tenant.order_by_name.distinct,
            :slug,
            :name,
            params[:publisher_slug],
          )
          select_tag('links_publisher_slug', options, prompt: 'Publishers')
        end

        def categories_select
          options = options_from_collection_for_select(
            ::Category.order_by_name.distinct,
            :slug,
            :name,
            params[:category_slug],
          )
          select_tag('links_category_slug', options, prompt: 'Categories')
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
          return if model.tags.blank?
          model.tags.order_by_name.pluck(:name).map do |tag|
            content_tag(:span, tag, class: 'links-tag')
          end
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
