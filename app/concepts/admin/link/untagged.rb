module Admin
  module Link
    module Cell
      class Untagged < Trailblazer::Cell
        def total
          number_with_delimiter(model.distinct.total_count)
        end

        def categories_select
          options = options_from_collection_for_select(
            ::Category.order_by_name.distinct,
            :slug,
            :name,
            params[:category_slug],
          )
          select_tag('untagged_links_category_slug', options, prompt: 'Categories')
        end
      end

      class UntaggedItem < Trailblazer::Cell
        property :url

        def published_at
          localize(model.published_at, format: :short)
        end

        def category_name
          model.category.try(:name)
        end

        def publisher_name
          model.publisher.name
        end

        def total_social
          number_with_delimiter(model.total_social)
        end
      end
    end
  end
end
