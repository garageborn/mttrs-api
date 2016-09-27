module Middleware
  module MaxPerforms
    class Client
      def call(worker_class, job, _queue, _redis_pool)
        options = MaxPerforms::Helper.parse_options(worker_class.to_s.constantize, job)
        performed_job = MaxPerforms::Helper.find(options)

        return yield if performed_job.blank?
        return unless should_enqueue?(performed_job, options)

        begin
          performed_job.enqueued!
          yield
        rescue StandardError => e
          performed_job.error!
          raise e
        end
      end

      private

      def should_enqueue?(performed_job, options)
        return true if Rails.env.development?
        return true if performed_job.blank?
        return false if performed_job.enqueued? || performed_job.running? || performed_job.success?
        performed_job.performs < options[:count].to_i
      end
    end
  end
end
