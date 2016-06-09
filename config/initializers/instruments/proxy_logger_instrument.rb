def logger
  if Rails.env.production? && ENV['LOGGLY_TOKEN'].present?
    @logger ||= Logglier.new(
      "https://logs-01.loggly.com/inputs/#{ ENV['LOGGLY_TOKEN'] }/tag/proxy/",
      threaded: true,
      format: :json
    )
  else
    @logger ||= Logger.new("#{ Rails.root }/log/proxy.log")
  end
end

def debug_log(type, payload)
  action = payload.delete(:action)
  payload[:exception].try(:delete, :backtrace)
  logger.send(type, "Proxy.#{ action } (#{ type }): #{ payload }")
end

ActiveSupport::Notifications.subscribe('proxy.logger') do |_name, _start, _finish, _id, payload|
  type = payload.delete(:type) || :info
  next debug_log(type, payload) if Rails.env.development?
  logger.send(type, payload)
end
