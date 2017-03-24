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
        if @params[:try_out]
          model.response = response
          model.onesignal_id = onesignal_id
        else
          model.update_attributes(response: response, onesignal_id: onesignal_id)
        end
      end

      def request
        request_params = query
        request_params[:included_segments] = ['Test User'] if @params[:try_out]
        OneSignal::Notification.create(params: request_params)
      end

      memoize :request
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
        Notification::Deliver::Link.run(@params)
      else
        Notification::Deliver::Text.run(@params)
      end
    end

    private

    def model!(params)
      params[:model] || ::Notification.find_by(id: params[:id])
    end
  end
end
