module MaxPerforms
  class Server
    def call(worker_class, job, _queue)
      options = MaxPerforms::Helper.parse_options(worker_class.class, job)
      performed_job = MaxPerforms::Helper.find(options)

      return yield if performed_job.blank?
      return unless should_perform?(performed_job, options)

      begin
        performed_job.enqueued!
        yield ? performed_job.success! : performed_job.error!
      rescue StandardError => e
        performed_job.error!
        raise e
      ensure
        performed_job.increment!(:performs)
      end
    end

    private

    def should_perform?(performed_job, options)
      return true if Rails.env.development?
      return false if performed_job.running? || performed_job.success?
      performed_job.performs < options[:count].to_i
    end
  end
end
