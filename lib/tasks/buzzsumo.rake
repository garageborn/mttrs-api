namespace :buzzsumo do
  namespace :fetcher do
    def enqueue_buzzsumo_fetcher(options)
      Publisher.random.all.each do |publisher|
        BuzzsumoFetcherJob.perform_async(publisher.id, options)
      end
    end

    desc 'Fetch all today links'
    task today: :environment do
      enqueue_buzzsumo_fetcher(
        begin_date: Time.zone.today.at_beginning_of_day.utc.to_i,
        end_date: Time.zone.today.end_of_day.utc.to_i
      )
    end

    desc 'Fetch all recent links'
    task recent: :environment do
      enqueue_buzzsumo_fetcher(
        begin_date: 3.days.ago.at_beginning_of_day.utc.to_i,
        end_date: 1.day.ago.end_of_day.utc.to_i
      )
    end
  end
end
