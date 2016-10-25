module Buzzsumo
  class Error < StandardError
    attr_reader :path, :headers

    def initialize(response)
      @path = response.request.last_uri.to_s
      @headers = response.headers.select do |key, _value|
        %w(x-ratelimit-reset x-ratelimit-limit x-ratelimit-month-remaining).include?(key)
      end
      @status = response.code
      super(response.error)
    end

    def raven_context
      { extra: { path: path, headers: headers } }
    end
  end
end
