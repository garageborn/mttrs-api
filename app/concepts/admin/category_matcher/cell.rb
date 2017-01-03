module Admin
  module CategoryMatcher
    module Cell
      class Index < Trailblazer::Cell
        def publishers_matchers
          model.all.group_by(&:publisher)
        end
      end

      class Item < Trailblazer::Cell
        def publisher
          model.first
        end

        def uncategorized_links
          number_with_delimiter(publisher.links.available_on_current_tenant.uncategorized.count)
        end

        def category_matchers
          model.second
        end
      end

      class Form < Trailblazer::Cell
        extend Memoist

        def matching_links
          return [] if model.url_matcher.blank? && model.html_matcher.blank?
          publisher_uncategorized_links.to_a.select do |link|
            LinkCategorizer::Matcher.new(model, link).match?
          end
        end

        def matching_links_count
          number_with_delimiter(matching_links.try(:size))
        end

        def uncategorized_links
          matching_links_ids = matching_links.map(&:id)
          publisher_uncategorized_links.where.not(id: matching_links_ids).limit(50)
        end

        def uncategorized_links_count
          count = number_with_delimiter(publisher_uncategorized_links.size)
          publisher = ::Publisher.find_by(id: model.publisher_id)
          return count if publisher.blank?
          path = uncategorized_admin_links_path(publisher_slug: publisher.slug)
          link_to(count, path, target: :_blank)
        end

        private

        def publisher_uncategorized_links
          publisher = ::Publisher.find_by(id: model.publisher_id)
          links = publisher.blank? ? ::Link.all : publisher.links
          links.available_on_current_tenant.uncategorized.popular
        end

        memoize :matching_links, :matching_links_count, :uncategorized_links,
                :uncategorized_links_count
      end
    end
  end
end
