module Middleware
  module UniqueJobs
    class Server
      def call(worker_class, job, queue_name)
        return yield if job['unique'].blank?

        Sidekiq::Queue.new(queue_name).to_a.each do |r|
          next if r['jid'] == job['jid']
          r.delete if r['class'] == job['class'] && r['args'] == job['args']
        end
        yield
      end
    end
  end
end
