lock '3.5.0'

set :application, 'mttrs-api'
set :repo_url, 'git@github.com:garageborn/mttrs-api.git'
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system'
)
set :deploy_to, '/home/ubuntu/mttrs-api'
set :branch, -> { ENV['branch'] || ask(:branch, `git rev-parse --abbrev-ref HEAD`.chomp) }
set :log_level, :info
set :ssh_options, forward_agent: true
set :root, File.expand_path(File.dirname(__FILE__) + '/../')

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{ fetch(:rbenv_path) } RBENV_VERSION=#{ fetch(:rbenv_ruby) } \
                   #{ fetch(:rbenv_path) }/bin/rbenv exec"
set :rbenv_map_bins, %w{ rake gem bundle ruby rails sidekiq sidekiqctl }
set :rbenv_roles, :all

# sidekiq
set :sidekiq_role, :worker

# whenever
set :whenever_identifier, -> { "#{ fetch(:application) }_#{ fetch(:stage) }" }
set :whenever_roles, -> { :scheduler }
set :whenever_config, -> { "#{ release_path }/config/schedule/#{ fetch(:stage) }.rb" }
set :whenever_command, lambda {
  [:bundle, :exec, :whenever, "--load-file #{ fetch(:whenever_config) }"]
}

# slack
set :slack_webhook, 'https://hooks.slack.com/services/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'
