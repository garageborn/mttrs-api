namespace :amp do
  desc 'Run AMP fetcher'
  task fetcher: :environment do
    AmpFetcherJob::REQUESTS_PER_WINDOW.times do
      AmpFetcherJob.new.perform
    end
  end
end
