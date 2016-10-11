namespace :buzzsumo do
  namespace :fetcher do
    def enqueue_buzzsumo_fetcher(options)
      Publisher.find_each(batch_size: 10) do |publisher|
        BuzzsumoFetcherJob.perform_async(publisher.id, options)
      end
    end

    desc 'Fetch all today links'
    task today: :environment do
      enqueue_buzzsumo_fetcher(
        begin_date: Date.today.at_beginning_of_day.utc.to_i
        end_date: Date.today.end_of_day.utc.to_i
      )
    end

    desc 'Fetch all yesterday links'
    task yesterday: :environment do
      enqueue_buzzsumo_fetcher(
        begin_date: Date.yesterday.at_beginning_of_day.utc.to_i
        end_date: Date.yesterday.end_of_day.utc.to_i
      )
    end

    desc 'Fetch all recent links'
    task since_7_days: :environment do
      enqueue_buzzsumo_fetcher(
        begin_date: 7.days.ago.at_beginning_of_day.utc.to_i
        end_date: 3.days.ago.end_of_day.utc.to_i
      )
    end
  end
end
