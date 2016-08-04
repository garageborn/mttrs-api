require 'httparty'

namespace :deploy do
  namespace :sentry do
    task :notify_deployment do
      current_revision = `cd /tmp/docker/repo && git log --pretty=format:'%h' -n 1`.chomp
      HTTParty.post(
        'https://app.getsentry.com/api/hooks/release/builtin/79019/7994174a298792ee9f90e6e37a986c04d1a955a804a14bb2773dbbaea1d92256/',
        body: {
          version: current_revision,
          ref: current_revision,
          url: "https://github.com/alexandrebini/mttrs-api/commit/#{ current_revision }"
        }.to_json
      )
    end
  end
end

Rake::Task['deploy:run'].enhance(['deploy:sentry:notify_deployment'])
