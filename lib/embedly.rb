class Embedly
  include HTTParty
  base_uri 'http://api.embed.ly/1'
  format :json
  parser OpenStructParser
  default_params key: ENV['EMBEDLY_TOKEN']

  def self.extract(url)
    self.get('/extract', query: { url: url })
  end
end
