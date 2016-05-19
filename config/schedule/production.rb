env :PATH, ENV['PATH']

every 3.hours do
  rake 'feeds:fetcher:run'
end

every 1.hour do
  rake 'stories:social:run'
end
