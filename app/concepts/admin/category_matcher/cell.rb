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
          number_with_delimiter(publisher.links.uncategorized.count)
        end

        def category_matchers
          model.second.sort_by(&:order)
        end
      end

      class Form < Trailblazer::Cell
        def matching_links
          return if model.url_matcher.blank?

          publisher_uncategorized_links.to_a.select do |link|
            LinkCategorizer::Matcher.new(model, link).match?
          end
        end

        def matching_links_count
          number_with_delimiter(matching_links.try(:size))
        end

        def uncategorized_links
          publisher_uncategorized_links.popular.limit(50)
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
          return ::Link.uncategorized.includes(:link_urls) if publisher.blank?
          publisher.links.uncategorized.includes(:link_urls)
        end
      end
    end
  end
end
