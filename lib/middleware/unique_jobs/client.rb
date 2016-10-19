module Middleware
  module UniqueJobs
    class Client
      def call(_worker_class, job, queue_name, _redis_pool)
        return yield if job['unique'].blank?

        Sidekiq::Queue.new(queue_name).to_a.each do |r|
          next if r['jid'] == job['jid']
          return false if r['class'] == job['class'] && r['args'] == job['args']
        end
        yield
      end
    end
  end
end
