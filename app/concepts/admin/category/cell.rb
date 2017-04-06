module Admin
  module Category
    module Cell
      class Index < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        property :id
        property :name
        property :order

        def image
          return if model.image_id.blank?
          cl_image_tag(model.image_id, width: 100, height: 100, crop: :fit)
        end

        def links_count
          number_with_delimiter(model.links.size)
        end

        def stories_count
          number_with_delimiter(model.stories.size)
        end
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
