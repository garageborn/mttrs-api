module Buzzsumo
  class Request
    include HTTParty
    base_uri 'http://api.buzzsumo.com'.freeze
    format :json
    parser Utils::OpenStructParser
    default_params api_key: ENV['BUZZSUMO_TOKEN']

    DEFAULT_RATELIMIT = 10
    DEFAULT_RATELIMIT_MONTH = 2_000
    DEFAULT_RATELIMIT_WINDOW = 15.seconds.to_i
    MAX_RATELIMIT_WINDOW = 5.minutes.to_i
    MAX_RETRIES = 10

    attr_accessor :method, :path, :options, :response

    def initialize(method, path, options)
      @method = method
      @path = path
      @options = options
      run!
    end

    private

    def run!
      with_retries(max_tries: MAX_RETRIES, rescue: ::Buzzsumo::Error) do
        sleep next_rate_limit_window if at_ratelimit?
        do_request
      end
    end

    def do_request
      @response = self.class.send(method, path, options)
      raise Buzzsumo::Error, response unless response.success?
      response
    end

    def at_ratelimit?
      return false if response.blank?
      response.code == 420 || ratelimit_remaining.zero?
    end

    def ratelimit_reset
      return 0 if response.blank?
      x_ratelimit_reset = Time.zone.at(response.headers['x-ratelimit-reset'].to_i)
      time_difference = (x_ratelimit_reset - Time.zone.now).to_i
      time_difference + DEFAULT_RATELIMIT_WINDOW
    end

    def ratelimit_month_remaining
      return DEFAULT_RATELIMIT_MONTH if response.blank?
      response.headers['x-ratelimit-month-remaining'].to_i
    end

    def ratelimit_remaining
      return DEFAULT_RATELIMIT if response.blank?
      response.headers['x-ratelimit-remaining'].to_i
    end

    def next_rate_limit_window
      return 0 if ratelimit_month_remaining.zero?
      [ratelimit_reset, MAX_RATELIMIT_WINDOW].min
    end
  end
end
