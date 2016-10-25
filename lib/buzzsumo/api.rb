module Buzzsumo
  class Api
    include HTTParty
    base_uri 'http://api.buzzsumo.com'.freeze
    format :json
    parser Utils::OpenStructParser
    default_params api_key: ENV['BUZZSUMO_TOKEN']
    ARTICLES_PATH = '/search/articles.json'.freeze

    class << self
      def articles(options)
        # do_request(:get, ARTICLES_PATH, options)
        begin
          do_request(:get, ARTICLES_PATH, options)
        rescue Exception => exception
          p '-aaaaaaaa'
          Raven.capture_exception(exception)
        end
      end

      def all(method, options = {})
        options[:query] ||= {}
        current_page = 0
        Array.new.tap do |resources|
          loop do
            options[:query][:page] = current_page
            request = send(method, options)
            resources.concat(request.parsed_response.results.to_a)
            current_page += 1
            break if end_reached?(current_page: current_page, request: request, options: options)
          end
        end.compact.uniq
      end

      private

      def end_reached?(current_page:, request:, options: {})
        total_pages = request.parsed_response.total_pages.to_i
        max_pages = options[:query][:max_pages]

        return true if current_page >= total_pages
        return true if max_pages.present? && current_page >= max_pages
        false
      end

      def do_request(method, path, options)
        request = send(method, path, options)
        raise ::Buzzsumo::Error.new(request) unless request.success?
        request
      end
    end
  end
end
