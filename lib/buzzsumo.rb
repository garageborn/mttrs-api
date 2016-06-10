class Buzzsumo
  include HTTParty
  base_uri 'http://api.buzzsumo.com'.freeze
  format :json
  parser OpenStructParser
  default_params api_key: ENV['BUZZSUMO_TOKEN']

  def self.articles(options)
    get('/search/articles.json'.freeze, options)
  end

  def self.all(method, options = {})
    options[:query] ||= {}
    current_page = 0
    Array.new.tap do |resources|
      loop do
        options[:query][:page] = current_page
        request = send(method, options)
        resources.concat(request.parsed_response.results.to_a)
        current_page += 1
        break unless current_page < request.parsed_response.total_pages.to_i
      end
    end.compact.uniq
  end
end
