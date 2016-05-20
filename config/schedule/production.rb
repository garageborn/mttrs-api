env :PATH, ENV['PATH']

every 15.minutes do
  rake 'feeds:fetcher:run'
end

every 1.hour do
  rake 'stories:social:run'
end
