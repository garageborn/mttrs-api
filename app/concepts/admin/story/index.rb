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

        def categories_filter
          categories = ::Category.ordered.map { |category| category_link(category) }
          [top_stories, with_summary] + categories
        end

        def tags_filter
          collection = ::Category.order_by_name.map do |category|
            next if category.tags.blank?
            tags = category.tags.order_by_name.map { |r| [r.name, r.slug] }
            [category.name, tags]
          end.compact.uniq

          grouped_options = grouped_options_for_select(collection, params[:tag_slug])
          select_tag('stories_tag_slug', grouped_options, prompt: 'Tags')
        end

        def search_input
          text_field_tag(
            'search',
            params[:search],
            id: 'stories_search',
            placeholder: 'Search', size: 50
          )
        end

        def top_stories
          link_to(
            'Top Stories',
            admin_stories_path(story_params.merge(category_slug: nil)),
            class: 'stories-add-button'
          )
        end

        def with_summary
          link_to(
            'Summaries',
            admin_stories_path(story_params.merge(with_summary: true, category_slug: nil)),
            class: 'stories-add-button'
          )
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
            admin_stories_path(story_params.merge(category_slug: category.slug, with_summary: nil)),
            class: 'stories-add-button'
          )
        end

        def story_params
          params.permit(:published_at, :category_slug, :search, :tag_slug, :with_summary)
        end
      end

      class Item < Trailblazer::Cell
        property :main_link

        def other_links
          model.other_links.popular
        end

        def image
          return if model.main_image_source_url.blank?
          image_tag(model.main_image_source_url, size: '100x100')
        end

        def category_name
          model.category.try(:name)
        end

        def published_at
          localize(model.published_at, format: :short)
        end

        def total_social
          number_with_delimiter(model.total_social)
        end

        def tags
          return if model.tags.blank?
          model.tags.order_by_name.pluck(:name).map do |tag|
            content_tag(:span, tag, class: 'links-tag')
          end
        end
      end

      class Link < Trailblazer::Cell
        property :id
        property :title
        property :url
        property :story

        def total_social
          number_with_delimiter(model.total_social)
        end

        def publisher_name
          model.publisher.name
        end

        def published_at
          localize(model.published_at, format: :short)
        end

        def tags
          return if model.tags.blank?
          model.tags.order_by_name.pluck(:name).map do |tag|
            content_tag(:span, tag, class: 'links-tag')
          end
        end
      end
    end
  end
end
