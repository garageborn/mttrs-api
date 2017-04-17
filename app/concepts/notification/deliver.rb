class Notification
  class Deliver < Operation
    class Base < Operation
      extend Memoist

      def process(*)
        return if model.blank? || query.blank?
        response = JSON.parse(request.response.body).with_indifferent_access
        update_model(response)
      rescue OneSignal::OneSignalError => error
        update_model(error.http_body)
      end

      def query
        raise 'Missing implementation'
      end

      private

      def model!(params)
        params[:model] || ::Notification.find_by(id: params[:id])
      end

      def update_model(response)
        onesignal_id = response.try(:[], :id) if response.is_a?(Hash)
        model.update_attributes(response: response, onesignal_id: onesignal_id)
      end

      def request
        OneSignal::Notification.create(params: query)
      end

      memoize :request
    end

    class Text < Base
      def query
        model.to_query(type: :text)
      end
    end

    class Category < Base
      def query
        category = model.try(:notificable)
        return if category.blank?
        model.to_query(
          type: :category,
          model: { id: category.id, slug: category.slug }
        )
      end
    end

    class Link < Base
      def query
        link = model.try(:notificable)
        return if link.blank?
        model.to_query(
          type: :link,
          model: { id: link.id, slug: link.slug }
        )
      end
    end

    class Publisher < Base
      def query
        publisher = model.try(:notificable)
        return if publisher.blank?
        model.to_query(
          type: :publisher,
          model: { id: publisher.id, slug: publisher.slug }
        )
      end
    end

    def process(*)
      return if model.blank?
      case model.notificable
      when ::Category then Notification::Deliver::Category.run(@params)
      when ::Link then Notification::Deliver::Link.run(@params)
      when ::Publisher then Notification::Deliver::Publisher.run(@params)
      else Notification::Deliver::Text.run(@params)
      end
    end

    private

    def model!(params)
      params[:model] || ::Notification.find_by(id: params[:id])
    end
  end
end
