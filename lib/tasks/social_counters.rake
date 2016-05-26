namespace :social_counters do
  def update(scope)
    scope.find_each(batch_size: 50) do |story|
      SocialCounterUpdateJob.perform_later(story.id)
    end
  end

  desc 'Fetch all social counts from recent stories'
  task recent: :environment do
    stories = Story.recent.created_since(2.days.ago)
    update(stories)
  end

  desc 'Fetch all social counts from yesterday stories'
  task since_30_days: :environment do
    stories = Story.recent.created_between(30.days.ago, 2.days.ago)
    update(stories)
  end

  desc 'Fetch all social counts from oldest stories'
  task oldest: :environment do
    stories = Story.recent.created_until(30.days.ago)
    update(stories)
  end
end
