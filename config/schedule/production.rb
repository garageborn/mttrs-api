env :PATH, ENV['PATH']

set :output, 'log/cron.log'
job_type :rake, 'cd :path && :environment_variable=:environment bin/rake :task --silent :path/:output'

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
