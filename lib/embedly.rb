class Embedly
  include HTTParty
  base_uri 'http://api.embed.ly/1'.freeze
  format :json
  parser OpenStructParser
  default_params key: ENV['EMBEDLY_TOKEN']

  def self.extract(url)
    get('/extract'.freeze, query: { url: url })
  end
end
