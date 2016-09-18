namespace :social_counters do
  def enqueue_social_counter_fetcher(links)
    links.find_each(batch_size: 100) do |link|
      SocialCounterFetcherJob.perform_async(link.id)
    end
  end

  desc 'Fetch all social counts from today links'
  task today: :environment do
    enqueue_social_counter_fetcher(Link.today)
  end

  desc 'Fetch all social counts from yesterday links'
  task yesterday: :environment do
    enqueue_social_counter_fetcher(Link.yesterday)
  end

  desc 'Fetch all social counts from recent links'
  task since_7_days: :environment do
    enqueue_social_counter_fetcher(Link.published_between(7.days.ago, 2.days.ago))
  end
end
