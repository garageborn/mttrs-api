require 'tempfile'
require 'date'

namespace :postgresql do
  POSTGRESQL_BACKUP_PATH = "/tmp/#{ Time.now.strftime('%Y%m%d%H%M%S') }.dump"
  POSTGRESQL_GZIP_PATH = "#{ POSTGRESQL_BACKUP_PATH }.tar.gz"

  def dump
    system <<-CMD
      export PGPASSWORD=$DB_PASSWORD
      pg_dump -h $DB_HOSTNAME -p $DB_PORT -U $DB_USERNAME -W $DB_NAME --no-password > #{ POSTGRESQL_BACKUP_PATH }
    CMD
  end

  def gzip
    system <<-CMD
      tar -czf #{ POSTGRESQL_GZIP_PATH } #{ POSTGRESQL_BACKUP_PATH }
    CMD
  end

  def upload
    `bundle exec rake s3_upload:file prefix=database path=#{ POSTGRESQL_GZIP_PATH }`
  end

  def cleanup
    system <<-CMD
      rm -rf #{ POSTGRESQL_BACKUP_PATH } #{ POSTGRESQL_GZIP_PATH }
    CMD
  end

  task :backup do
    begin
      dump
      gzip
      puts upload
    ensure
      cleanup
    end
  end
end
