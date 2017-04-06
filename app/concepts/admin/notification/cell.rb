module Admin
  module Notification
    module Cell
      class Form < Trailblazer::Cell
      end

      class Index < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        property :accessable

        def label
          return model.title if model.title.present?
          truncate(model.message, length: 100)
        end

        def created_at
          localize(model.created_at, format: :short)
        end

        def onesignal_link
          return if model.onesignal_id.blank?
          link_to(model.onesignal_id, model.onesignal_url, target: :_blank)
        end
      end
    end
  end
end
