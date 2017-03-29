module Admin
  module CategoryMatcher
    module Cell
      class Index < Trailblazer::Cell
        # def publishers_matchers
        #   model.all.group_by(&:publisher)
        # end
      end

      class Publisher < Trailblazer::Cell
        def publisher
          model.first
        end

        def uncategorized_links
          number_with_delimiter(publisher.links.available_on_current_tenant.uncategorized.count)
        end

        def category_matchers
          model.second.sort_by { |r| r.category.name }.group_by(&:category)
        end
      end

      class Item < Trailblazer::Cell
        property :order
        property :url_matcher
        property :html_matcher
        property :html_matcher_selector

        def publisher_name
          model.publisher.name
        end

        def category_name
          model.category.name
        end
      end

      class Form < Trailblazer::Cell
        extend Memoist

        def matching_links
          return [] if model.url_matcher.blank? && model.html_matcher.blank?
          publisher_uncategorized_links.to_a.select do |link|
            model.match?(link)
          end
        end

        def matching_links_count
          number_with_delimiter(matching_links.uniq.try(:size))
        end

        def uncategorized_links
          matching_links_ids = matching_links.map(&:id)
          publisher_uncategorized_links.where.not(id: matching_links_ids).limit(50)
        end

        def uncategorized_links_count
          count = number_with_delimiter(publisher_uncategorized_links.uniq.size)
          publisher = ::Publisher.find_by(id: model.publisher_id)
          return count if publisher.blank?
          path = uncategorized_admin_links_path(publisher_slug: publisher.slug)
          link_to(count, path, target: :_blank)
        end

        private

        def publisher_uncategorized_links
          publisher = ::Publisher.find_by(id: model.publisher_id)
          links = publisher.blank? ? ::Link.all : publisher.links
          links.available_on_current_tenant.uncategorized.order_by_url
        end

        memoize :matching_links, :matching_links_count, :uncategorized_links,
                :uncategorized_links_count
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
      end
    end
  end
end
