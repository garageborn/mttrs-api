module Admin
  module Story
    module Cell
      class Form < Trailblazer::Cell
        extend Memoist
        INCLUDES = %i(category publisher story link_url).freeze

        def links
          model.links.popular.includes(INCLUDES)
        end

        def blocked_links
          model.blocked_links.popular.includes(INCLUDES)
        end

        def notification_link
          main_link = model.main_link
          return if main_link.blank?

          options = { notificable_type: 'Link', notificable_id: main_link.id }
          if model.summary.present?
            options.merge!(
              message: "#{ main_link.title }\n#{ model.summary }",
              icon_url: model.main_image_source_url
            )
          else
            options.merge!(message: main_link.title, image_url: model.main_image_source_url)
          end
          link_to 'Create Notification', [:new, :admin, :notification, { notification: options }]
        end
      end
    end
  end
end
