require 'httparty'

namespace :sentry do
  task :notify_deployment do
    HTTParty.post(
      'https://app.getsentry.com/api/hooks/release/builtin/79019/7994174a298792ee9f90e6e37a986c04d1a955a804a14bb2773dbbaea1d92256/',
      body: {
        version: fetch(:release_timestamp),
        ref: fetch(:current_revision)
      }.to_json
    )
  end
end
after 'deploy:published', 'sentry:notify_deployment'
