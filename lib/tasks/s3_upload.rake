require 'fog'

Fog::Logger[:warning] = nil

namespace :s3_upload do
  def connection
    @connection ||= Fog::Storage.new({
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    })
  end

  def bucket(prefix)
    connection.directories.create(key: "#{ ENV['S3_BUCKET_NAME'] }/#{ prefix }")
  end

  task :file, :environment do
    prefix = ENV['prefix']
    path = ENV['path']
    expiry = ENV['expiry'] || 30.minutes.from_now

    dir = bucket(prefix)

    file = dir.files.create(
      key: File.basename(path),
      body: File.open(path)
    )
    puts file.url(expiry)
  end
end
