module Admin
  module Notification
    module Cell
      class Form < Trailblazer::Cell
        SEGMENTS = [
          'mttrs_br test',
          'mttrs_br',
          'mttrs_us test',
          'mttrs_us'
        ].freeze

        def types_collection
          %w(Link Category Publisher)
        end

        def segments_collection
          SEGMENTS.select { |segment| segment.starts_with?(Apartment::Tenant.current) }
        end
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
