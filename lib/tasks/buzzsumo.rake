namespace :buzzsumo do
  namespace :fetcher do
    desc 'Run Buzzsumo fetcher job'
    task run: :environment do
      BuzzsumoFetcherJob.perform_later
    end
  end
end
