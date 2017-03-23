class Notification
  class Deliver < Operation
    action :find

    class Base < Operation
      action :find

      def process(*)
        return if model.blank? || query.blank?
        request = OneSignal::Notification.create(params: query)
        response = JSON.parse(request.response.body).with_indifferent_access

        model.update_attributes(
          response: response,
          onesignal_id: response[:id]
        )
      rescue OneSignal::OneSignalError => error
        model.update_attributes(response: error.http_body)
      end

      def query
        raise 'Missing implementation'
      end
    end

    class Text < Base
      def query
        model.to_query(type: :text)
      end
    end

    class Link < Base
      def query
        link = model.try(:notificable)
        return if link.blank?
        model.to_query(
          type: :link,
          model: {
            id: link.id,
            slug: link.slug,
            story: { id: link.story.try(:id) }
          }
        )
      end
    end

    def process(*)
      return if model.blank?
      if model.notificable.is_a?(::Link)
        Notification::Deliver::Link.run(id: model.id)
      else
        Notification::Deliver::Text.run(id: model.id)
      end
    end
  end
end
