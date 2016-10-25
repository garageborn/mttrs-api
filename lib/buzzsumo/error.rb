module Buzzsumo
  class Error < StandardError
    attr_reader :path, :headers
    RATELIMIT_HEADERS = %w(
      x-ratelimit-reset
      x-ratelimit-limit
      x-ratelimit-remaining
      x-ratelimit-month-remaining
    ).freeze

    def initialize(response)
      @path = response.request.last_uri.to_s
      @headers = response.headers.select { |key, _value| RATELIMIT_HEADERS.include?(key) }
      @status = response.code
      super(response.error)
    end

    def raven_context
      { extra: { path: path, headers: headers } }
    end
  end
end
