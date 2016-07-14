env :PATH, ENV['PATH']

every 10.minutes do
  rails 'links:fetcher:run'
end

every 1.hour do
  rails 'social_counters:recent'
end

every 1.day, at: '2am' do
  rails 'social_counters:since_7_days'
end

every 1.day, at: '3am' do
  rails 'links:purge'
end
