module Admin
  module Story
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper

        property :title
        property :links

        def image
          return if model.image_source_url.blank?
          image_tag(model.image_source_url, size: '150x100')
        end

        def categories_names
          model.categories.pluck(:name).to_sentence
        end

        def publishers_names
          model.publishers.pluck(:name).to_sentence
        end
      end

      class SocialCounter < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper

        def total_social
          number_with_delimiter(model.total_social)
        end

        def total_facebook
          number_with_delimiter(model.total_facebook)
        end

        def total_linkedin
          number_with_delimiter(model.total_linkedin)
        end

        def total_twitter
          number_with_delimiter(model.total_twitter)
        end

        def total_pinterest
          number_with_delimiter(model.total_pinterest)
        end

        def total_google_plus
          number_with_delimiter(model.total_google_plus)
        end
      end

      class Link < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper
        property :title

        def categories_names
          model.categories.pluck(:name).to_sentence
        end

        def publisher_name
          model.publisher.name
        end
      end
    end
  end
end
