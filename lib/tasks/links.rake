namespace :links do
  namespace :fetcher do
    desc 'Run Links fetcher'
    task run: :environment do
      Rake::Task['buzzsumo:fetcher:run'].invoke
      Rake::Task['feeds:fetcher:run'].invoke
    end
  end
end
