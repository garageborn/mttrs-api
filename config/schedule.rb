env :PATH, ENV['PATH']

set :output, 'log/cron.log'
job_type :rake, 'cd :path && :environment_variable=:environment bin/rake :task --silent :path/:output'

# Buzzsumo
every 25.minutes do
  rake 'buzzsumo:fetcher:today'
end

every 6.hours do
  rake 'buzzsumo:fetcher:recent'
end

every 1.day, at: '2am' do
  rake 'buzzsumo:fetcher:since_7_days'
end

# Links
every 1.day, at: '3am' do
  rake 'links:purge:run'
end
