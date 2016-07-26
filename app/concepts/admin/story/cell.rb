module Admin
  module Story
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper
        property :title

        def image
          return if image_url.blank?
          image_tag(image_url)
        end

        def categories
          model.categories.pluck(:name).to_sentence
        end

        def social_counter
          concept('admin/link/cell/social_counter', main_link)
        end

        private

        def main_link
          model.main_link || model.links.order(total_social: :desc).first
        end

        def image_url
          return if model.image_source_url.blank?
          Cloudinary::Utils.cloudinary_url(
            model.image_source_url,
            type: 'fetch', width: 200, height: 200, crop: 'fit'
          )
        end
      end
    end
  end
end
