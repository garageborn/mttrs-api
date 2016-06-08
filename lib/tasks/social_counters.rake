namespace :social_counters do
  def update(scope)
    scope.find_each(batch_size: 50) do |story|
      SocialCounterFetcherJob.perform_later(story.id)
    end
  end

  desc 'Fetch all social counts from recent stories'
  task recent: :environment do
    stories = Story.recent.published_since(2.days.ago)
    update(stories)
  end

  desc 'Fetch all social counts from yesterday stories'
  task since_7_days: :environment do
    stories = Story.recent.published_between(7.days.ago, 2.days.ago)
    update(stories)
  end
end
