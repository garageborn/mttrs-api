namespace :social_counters do
  def enqueue_social_counter_fetcher(link_ids)
    p link_ids
    link_ids.each { |id| SocialCounterFetcherJob.perform_async(id) }
  end

  def tenant_story_link_ids
    link_ids = []
    Apartment::Tenant.each { link_ids += yield.map(&:link_ids) }
    link_ids.flatten.compact.uniq.to_a
  end

  desc 'Fetch all social counts from today links'
  task today: :environment do
    link_ids = tenant_story_link_ids { Story.today }
    enqueue_social_counter_fetcher(link_ids)
  end

  desc 'Fetch all social counts from yesterday links'
  task yesterday: :environment do
    link_ids = tenant_story_link_ids { Story.yesterday }
    enqueue_social_counter_fetcher(link_ids)
  end

  desc 'Fetch all social counts from recent links'
  task since_7_days: :environment do
    link_ids = tenant_story_link_ids { Story.published_between(7.days.ago, 2.days.ago) }
    enqueue_social_counter_fetcher(link_ids)
  end
end
