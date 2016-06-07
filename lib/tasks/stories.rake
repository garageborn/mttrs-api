namespace :stories do
  namespace :fetcher do
    desc 'Run Stories fetcher'
    task run: :environment do
      Rake::Task['buzzsumo:fetcher:run'].invoke
      Rake::Task['feeds:fetcher:run'].invoke
    end
  end
end
