env :PATH, ENV['PATH']

set :output, 'log/cron.log'
job_type :rake, 'cd :path && :environment_variable=:environment bin/rake :task --silent :path/:output'

# Buzzsumo
every 40.minutes do
  rake 'buzzsumo:fetcher:today'
end

every 12.hours do
  rake 'buzzsumo:fetcher:recent'
end

# Links
every 1.day, at: '3am' do
  rake 'links:purge:run'
end

# AMP
every 5.minutes do
  rake 'amp:fetcher'
end
