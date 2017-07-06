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
          return if model.icon.blank?
          image_tag(model.icon.url(:xsmall))
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
