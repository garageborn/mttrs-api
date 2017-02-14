module Admin
  module Concerns
    module Timezone
      extend ActiveSupport::Concern

      included do
        before_action :set_timezone
      end

      private

      def set_timezone
        x_timezone = request.headers['HTTP_X_TIMEZONE']
        Time.zone = x_timezone if x_timezone.present?
      end
    end
  end
end
