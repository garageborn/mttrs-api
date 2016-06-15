class UserAgent
  USER_AGENTS = {
    googlebot: 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
  }.freeze

  def self.sample
    USER_AGENTS.values.sample
  end
end
