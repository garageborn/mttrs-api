module Proxy
  autoload :GimmeProxy, './lib/proxy/gimme_proxy'
  RESCUE_FROM = [Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError, Timeout::Error].freeze
  DEFAULT_TIMEOUT = 10
  MAX_RETRIES = 7

  class << self
    extend Memoist
    attr_accessor :current_source, :current_proxy

    def request(url, options: {}, method: :get, max_tries: MAX_RETRIES)
      current_source, current_proxy = get_proxy

      handler = proc do
        current_source.fail(current_proxy)
        current_source, current_proxy = get_proxy
      end

      with_retries(max_tries: max_tries, handler: handler, rescue: RESCUE_FROM) do |attempt|
        options = parse_options(options, attempt: attempt, current_proxy: current_proxy)
        logging(attempt: attempt, url: url, method: method, options: options) do
          call(method, url, options)
        end
      end
    end

    private

    def call(method, url, options)
      HTTParty.send(method, url, options).tap do |request|
        raise Errno::ECONNREFUSED unless request.success?
      end
    end

    def parse_options(options, attempt:, current_proxy: nil)
      options[:timeout] ||= DEFAULT_TIMEOUT

      if attempt == MAX_RETRIES || current_proxy.blank?
        options.delete(:http_proxyaddr)
        options.delete(:http_proxyport)
      else
        options[:http_proxyaddr] = current_proxy[:host]
        options[:http_proxyport] = current_proxy[:port]
      end

      options
    end

    def get_proxy
      current_source = sources.sample
      current_proxy = current_source.sample
      [current_source, current_proxy]
    end

    def sources
      [GimmeProxy.instance]
    end

    def logging(options)
      default_options = { type: :info, action: :request, request_id: SecureRandom.uuid }
      payload = default_options.merge(options)
      ActiveSupport::Notifications.instrument('proxy.logger', payload.merge(status: :pending))
      response = yield
      ActiveSupport::Notifications.instrument('proxy.logger', payload.merge(status: :success))
      response
    rescue StandardError => e
      payload = default_options.merge(
        type: :error,
        status: :error,
        exception: { message: e.message, backtrace: e.backtrace.join("\n") }
      )
      ActiveSupport::Notifications.instrument('proxy.logger', payload)
      raise(e)
    end

    memoize :sources
  end
end
