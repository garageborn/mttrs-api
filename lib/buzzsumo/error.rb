module Buzzsumo
  class Error < StandardError
    attr_reader :headers, :path, :raised_at, :status

    RATELIMIT_HEADERS = %w[
      x-ratelimit-reset
      x-ratelimit-limit
      x-ratelimit-remaining
      x-ratelimit-month-remaining
    ].freeze

    def initialize(response)
      @headers = response.headers.select { |key, _value| RATELIMIT_HEADERS.include?(key) }
      @path = response.request.last_uri.to_s.gsub(ENV['BUZZSUMO_TOKEN'], '')
      @status = response.code
      @raised_at = Time.now.utc.to_i
      super(response.error)
    end

    def raven_context
      {
        extra: {
          headers: headers,
          path: path,
          status: status,
          raised_at: raised_at
        }
      }
    end
  end
end
