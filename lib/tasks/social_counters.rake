namespace :social_counters do
  def enqueue_social_counter_fetcher(stories)
    stories.find_each do |story|
      story.links.find_each(batch_size: 50) do |link|
        SocialCounterFetcherJob.perform_async(link.id)
      end
    end
  end

  desc 'Fetch all social counts from today links'
  task today: :environment do
    enqueue_social_counter_fetcher(Story.today)
  end

  desc 'Fetch all social counts from yesterday links'
  task yesterday: :environment do
    enqueue_social_counter_fetcher(Story.yesterday)
  end

  desc 'Fetch all social counts from recent links'
  task since_7_days: :environment do
    enqueue_social_counter_fetcher(Story.published_between(7.days.ago, 2.days.ago))
  end
end
