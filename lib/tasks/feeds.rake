namespace :feeds do
  namespace :fetcher do
    desc 'Fetch all feeds'
    task run: :environment do
      Feed.find_each(batch_size: 10) do |feed|
        FeedFetcherJob.perform_later(feed.id)
      end
    end
  end
end
