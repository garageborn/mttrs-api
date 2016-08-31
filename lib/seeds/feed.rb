module Seeds
  class Feed
    def self.run!
      seed = JSON.parse(File.open("#{ Rails.root }/db/feeds.json").read)

      seed.each do |feed|
        category = Category.find_or_initialize_by(name: feed[0])

        if category.new_record?
          Rails.logger.info '* '
          category.save
        else
          Rails.logger.info '- '
        end

        Rails.logger.info category.name

        feed[1].each do |publisher, url|
          publisher = Publisher.find_or_initialize_by(name: publisher)
          feed = Feed.find_or_initialize_by(url: url)

          if publisher.new_record?
            Rails.logger.info '  * '
            publisher.save
          else
            Rails.logger.info '  - '
          end

          Rails.logger.info publisher.name

          if feed.new_record?
            Rails.logger.info '    * '
            feed.category = category
            feed.publisher = publisher
            feed.save
          else
            Rails.logger.info '    - '
          end

          Rails.logger.info feed.url
          Rails.logger.info
        end

        Rails.logger.info
      end
    end
  end
end
