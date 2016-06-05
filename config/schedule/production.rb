env :PATH, ENV['PATH']

every 15.minutes do
  rake 'feeds:fetcher:run'
end

every 15.minutes do
  rake 'buzzsumo:fetcher:run'
end

# every 1.hour do
#   rake 'social_counters:recent'
# end

# every 1.day, at: '2am' do
#   rake 'social_counters:since_30_days'
# end

# every :month, at: '4am' do
#   rake 'social_counters:oldest'
# end
