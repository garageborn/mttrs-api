module Concerns
  module Timezone
    extend ActiveSupport::Concern

    included do
      before_action :set_timezone
    end

    private

    def set_timezone
      timezone = x_timezone || x_geoip_timezone
      return if timezone.blank?
      Time.zone = timezone
    end

    def x_timezone
      timezone = request.headers['HTTP_X_TIMEZONE']
      return timezone if timezone.present? && ActiveSupport::TimeZone[timezone].present?
    end

    def x_geoip_timezone
      timezone = request.headers['HTTP_GEOIP_TIMEZONE']
      return timezone if timezone.present? && ActiveSupport::TimeZone[timezone].present?
    end
  end
end
