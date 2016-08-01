namespace :links do
  namespace :fetcher do
    desc 'Run Links fetcher'
    task run: :environment do
      # Rake::Task['buzzsumo:fetcher:run'].invoke
      Rake::Task['feeds:fetcher:run'].invoke
    end
  end

  desc 'Purge useless links'
  task purge: :environment do
    links = Link.published_until(7.days.ago).where(total_social: 0)
    Rails.logger.info "links:purge #{ links.count }"
    links.destroy_all
  end
end
