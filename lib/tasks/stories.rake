namespace :stories do
  namespace :social do
    desc 'Fetch all social counts'
    task run: :environment do
      Story.find_each(batch_size: 50) do |story|
        StorySocialFetcherJob.perform_later(story.id)
      end
    end
  end
end
