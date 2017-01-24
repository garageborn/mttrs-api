lock '3.7.1'

set :application, 'mttrs-api'
set :repo_url, 'git@github.com:garageborn/mttrs-api.git'
set :keep_releases, 10
set :deploy_to, '/home/garageborn/mttrs-api'
set :pty, true
set :root, File.expand_path(File.dirname(__FILE__) + '/../')
set :ssh_options, { forward_agent: true, port: 41858 }
set :branch, -> { ENV['branch'] || `git rev-parse --abbrev-ref HEAD`.chomp }
set :use_sudo, false
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{ fetch(:rbenv_path) } RBENV_VERSION=#{ fetch(:rbenv_ruby) } #{ fetch(:rbenv_path) }/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

# whenever
set :whenever_identifier, -> { fetch(:application) }
set :whenever_roles, -> { :worker }
set :whenever_config, -> { "#{ release_path }/config/schedule/schedule.rb" }
set :whenever_command, -> {
  [:bundle, :exec, :whenever, "--load-file #{ fetch(:whenever_config) }"]
}

# puma
set :puma_conf, -> { "#{ release_path }/config/puma.rb" }
