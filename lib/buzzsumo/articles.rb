module Buzzsumo
  class Articles
    ARTICLES_PATH = '/search/articles.json'.freeze

    class << self
      def get(options)
        ::Buzzsumo::Request.new(:get, ARTICLES_PATH, options).response
      end

      def all(options = {})
        options[:query] ||= {}
        current_page = 0
        [].tap do |resources|
          loop do
            options[:query][:page] = current_page
            request = get(options)
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
    end
  end
end
