env :PATH, ENV['PATH']

every 10.minutes do
  rake 'stories:fetcher:run'
end

every 1.hour do
  rake 'social_counters:recent'
end

every 1.day, at: '2am' do
  rake 'social_counters:since_7_days'
end
