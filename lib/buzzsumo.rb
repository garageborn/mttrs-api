class Buzzsumo
  include HTTParty
  base_uri 'http://api.buzzsumo.com'.freeze
  format :json
  parser OpenStructParser
  default_params api_key: ENV['BUZZSUMO_TOKEN']

  def self.articles(options)
    get('/search/articles.json'.freeze, options)
  end
end
