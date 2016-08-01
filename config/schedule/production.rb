env :PATH, ENV['PATH']

# Social Counters
every 20.minutes do
  rake 'social_counters:today'
end

every 1.hour do
  rake 'social_counters:yesterday'
end

every 1.day, at: '2am' do
  rake 'social_counters:since_7_days'
end

# Links
every 10.minutes do
  rake 'links:fetcher:run'
end

every 1.day, at: '3am' do
  rake 'links:purge'
end

# Proxies
every 90.minutes do # 1.000 requests per 24 hours allowed, 60 requests per minute
  rake 'proxies:import:gimme_proxy'
end
