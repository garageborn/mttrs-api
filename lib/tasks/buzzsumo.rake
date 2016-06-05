namespace :buzzsumo do
  namespace :fetcher do
    desc 'Run Buzzsumo fetcher job'
    task run: :environment do
      Publisher.find_each(batch_size: 10) do |publisher|
        BuzzsumoFetcherJob.perform_later(publisher.id)
      end
    end
  end
end
