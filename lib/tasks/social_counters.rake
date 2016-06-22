namespace :social_counters do
  def update(scope)
    scope.find_each(batch_size: 50) do |link|
      SocialCounterFetcherJob.perform_later(link.id)
    end
  end

  desc 'Fetch all social counts from recent links'
  task recent: :environment do
    links = Link.recent.published_since(2.days.ago)
    update(links)
  end

  desc 'Fetch all social counts from yesterday links'
  task since_7_days: :environment do
    links = Link.recent.published_between(7.days.ago, 2.days.ago)
    update(links)
  end
end
