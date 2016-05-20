namespace :feeds do
  namespace :fetcher do
    desc 'Fetch all feeds'
    task run: :environment do
      Feed.find_each(batch_size: 10) do |feed|
        FeedFetcherJob.perform_later(feed.id)
      end
    end
  end

  task :update => :environment do
    json = File.open("#{Rails.root}/lib/feeds.json").read
    json_feeds = JSON.parse(json)

    json_feeds.each do |feed|
      category = Category.find_or_initialize_by(name: feed[0])

      if category.new_record?
        print '* '
        category.save
      else
        print '- '
      end

      puts category.name

      feed[1].each do |publisher, url|
        publisher = Publisher.find_or_initialize_by(name: publisher)
        feed = Feed.find_or_initialize_by(url: url)

        if publisher.new_record?
          print '  * '
          publisher.save
        else
          print '  - '
        end

        puts publisher.name

        if feed.new_record?
          print '    * '
          feed.category = category
          feed.publisher = publisher
          feed.save
        else
          print '    - '
        end

        puts feed.url
        puts
      end

      puts
    end
  end
end
