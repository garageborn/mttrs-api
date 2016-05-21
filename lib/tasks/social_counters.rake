namespace :social_counters do
  desc 'Fetch all social counts'
  task update: :environment do
    Story.find_each(batch_size: 50) do |story|
      SocialCounterUpdateJob.perform_later(story.id)
    end
  end
end
