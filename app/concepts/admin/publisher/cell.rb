module Admin
  module Publisher
    module Cell
      class Index < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        property :id
        property :name
        property :domain
        property :language
        property :restrict_content

        def icon
          return if model.icon_id.blank?
          cl_image_tag(model.icon_id, width: 24, height: 24, crop: :fit)
        end

        def links_count
          number_with_delimiter(model.links.size)
        end

        def today_links_count
          number_with_delimiter(model.links.today.size)
        end
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
