module Utils
  class Thread
    def self.with_connection(&block)
      ActiveRecord::Base.connection_pool.with_connection do
        yield block
      end
    rescue StandardError => e
      raise e
    ensure
      # Check the connection back in to the connection pool
      ActiveRecord::Base.connection.close if ActiveRecord::Base.connection
    end
  end
end
