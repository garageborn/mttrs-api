require 'uri'

namespace :postgresql do
  desc 'Create a postgresql dump'
  task :backup do
    on roles(:db) do
      within current_path do
        rake_output = capture(:bundle, :exec, :rake, 'postgresql:backup')
        backup_uri = URI.parse(URI.extract(rake_output).last)

        output = "#{ fetch(:root) }/tmp/#{ File.basename(backup_uri.path) }"
        system <<-CMD
          wget "#{ backup_uri }" --output-document=#{ output }
        CMD
      end
    end
  end

  desc 'Restore'
  task :restore do
    invoke 'postgresql:backup'
    last_dump = Dir.glob("#{ fetch(:root) }/tmp/*.dump.tar.gz").max_by { |f| File.mtime(f) }
    system("tar -zxvf #{ last_dump }")
    system("psql mttrs_development --command='drop schema public cascade;create schema public;'")
    system("psql mttrs_development < #{ last_dump.gsub('.tar.gz', '') }")
  end
end
