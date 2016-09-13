namespace :links do
  namespace :fetcher do
    desc 'Run Links fetcher'
    task run: :environment do
      # Rake::Task['buzzsumo:fetcher:run'].invoke
      Rake::Task['feeds:fetcher:run'].invoke
    end
  end

  namespace :purge do
    desc 'Run Links fetcher'
    task run: :environment do
      Rake::Task['links:purge:week'].invoke
      Rake::Task['links:purge:month'].invoke
    end

    desc 'Purge useless links created this week'
    task week: :environment do
      links = Link.published_until(7.days.ago).where(total_social: 0)
      Rails.logger.info "links:purge #{ links.count }"
      links.find_each { |link| Link::Destroy.run(id: link.id) }
    end

    desc 'Purge useless links created this month'
    task month: :environment do
      links = Link.published_until(30.days.ago)
      Rails.logger.info "links:purge #{ links.count }"
      links.find_each { |link| Link::Destroy.run(id: link.id) }
    end
  end
end
