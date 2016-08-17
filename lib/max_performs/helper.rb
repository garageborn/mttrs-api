module MaxPerforms
  module Helper
    class << self
      def parse_options(worker_class, job)
        sidekiq_options = worker_class.sidekiq_options.with_indifferent_access
        sidekiq_options[:max_performs].to_h.merge(
          type: worker_class.to_s,
          args: job.deep_symbolize_keys[:args]
        ).deep_symbolize_keys
      end

      def find(options)
        return if options.blank? || options[:key].blank?
        key = options[:key].call(*options[:args])
        return if key.blank?
        PerformedJob.where(type: options[:type], key: key).first_or_create
      rescue ActiveRecord::RecordNotUnique
        PerformedJob.find(type: options[:type], key: key)
      end
    end
  end
end
