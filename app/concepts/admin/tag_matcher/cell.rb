module Admin
  module TagMatcher
    module Cell
      class Index < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        property :name

        def tag_name
          model.tag.name
        end

        def category_name
          model.category.name
        end

        def publisher_name
          model.publisher.name
        end
      end

      class Form < Trailblazer::Cell
        extend Memoist

        def publishers_collection
          ::Category.order_by_name.map do |category|
            next if category.publishers.blank?
            publishers = category.publishers.order_by_name.map { |r| [r.name, r.id] }
            [category.name, publishers]
          end.compact.uniq
        end

        def tags_collection
          ::Category.order_by_name.map do |category|
            next if category.tags.blank?
            tags = category.tags.order_by_name.map { |r| [r.name, r.id] }
            [category.name, tags]
          end.compact.uniq
        end

        def matching_links
          return [] if model.url_matcher.blank? && model.html_matcher.blank?
          publisher_untagged_links.to_a.select { |link| link_matcher.match?(link) }
        end

        def matching_links_count
          number_with_delimiter(matching_links.uniq.try(:size))
        end

        def untagged_links_count
          number_with_delimiter(untagged_links.uniq.size)
        end

        def untagged_links
          matching_links_ids = matching_links.map(&:id)
          publisher_untagged_links.where.not(id: matching_links_ids).limit(50)
        end

        private

        def publisher_untagged_links
          publisher = ::Publisher.find_by(id: model.publisher_id)
          tag = ::Tag.find_by(id: model.tag_id)
          return ::Link.untagged.available_on_current_tenant.order_by_url if publisher.blank?

          scope = if tag.present?
                    publisher.links.category_slug(tag.category.slug).without_tag(tag.id)
                  else
                    publisher.links.untagged
                  end

          scope.available_on_current_tenant.order_by_url
        end

        def link_matcher
          ::LinkMatcher.new(
            url_matcher: model.url_matcher,
            html_matcher: model.html_matcher,
            html_matcher_selector: model.html_matcher_selector
          )
        end

        memoize :link_matcher, :publishers_collection, :tags_collection,
                :matching_links, :matching_links_count, :untagged_links, :untagged_links_count,
                :publisher_untagged_links
      end

      class Links < Trailblazer::Cell
        def links
          options[:links]
        end
      end

      class Link < Trailblazer::Cell
        property :url

        def published_at
          localize(model.published_at, format: :short)
        end

        def total_social
          number_with_delimiter(model.total_social)
        end

        def tags
          model.tags.pluck(:name).sort.to_sentence
        end

        def html
          return 'yes' if model.html.present?
        end
      end
    end
  end
end
