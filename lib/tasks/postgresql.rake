namespace :postgresql do
  POSTGRESQL_BACKUP_PATH = "/tmp/#{ Time.now.strftime('%Y%m%d%H%M%S') }.dump".freeze
  POSTGRESQL_GZIP_PATH = "#{ POSTGRESQL_BACKUP_PATH }.tar.gz".freeze

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
      rm -rf /tmp/*.dump /tmp/*.dump.tar.gz
    CMD
  end

  task backup: :environment do
    begin
      dump
      gzip
      puts upload
    ensure
      cleanup
    end
  end
end
