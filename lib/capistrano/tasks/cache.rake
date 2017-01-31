namespace :cache do
  desc 'Clear cache'
  task :clear do
    on roles(:db) do
      within release_path do
        execute(:bundle, :exec, :rails, :runner, 'Rails.cache.clear')
      end
    end
  end

  before 'deploy:finished', 'cache:clear'
end
