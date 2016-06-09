class UserAgent
  USER_AGENTS = {
    chrome: 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) ' \
            'Chrome/41.0.2228.0 Safari/537.36',
    firefox: 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1',
    safari: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 ' \
            '(KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'
  }.freeze

  def self.sample
    USER_AGENTS.values.sample
  end
end
