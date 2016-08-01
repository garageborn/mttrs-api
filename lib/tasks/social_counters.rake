namespace :social_counters do
  def enqueue_social_counter_fetcher(scope)
    scope.find_each(batch_size: 50) do |link|
      SocialCounterFetcherJob.perform_later(link.id)
    end
  end

  desc 'Fetch all social counts from today links'
  task today: :environment do
    enqueue_social_counter_fetcher(Link.today.recent)
  end

  desc 'Fetch all social counts from yesterday links'
  task yesterday: :environment do
    enqueue_social_counter_fetcher(Link.yesterday.recent)
  end

  desc 'Fetch all social counts from recent links'
  task since_7_days: :environment do
    enqueue_social_counter_fetcher(Link.recent.published_between(7.days.ago, 2.days.ago))
  end
end
