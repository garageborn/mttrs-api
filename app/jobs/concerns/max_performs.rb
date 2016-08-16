module Concerns
  module MaxPerforms
    extend ActiveSupport::Concern
    # extend Memoist

    included do
      class_attribute :max_performs_options

      def self.max_performs(performs, key:)
        self.max_performs_options = {
          performs: performs,
          key: key,
          type: to_s
        }
      end

      # around_enqueue do |_job, block|
      #   next unless should_enqueue?

      #   begin
      #     block.call
      #     performed_job.enqueued!
      #   rescue StandardError => e
      #     performed_job.error!
      #     raise e
      #   end
      # end

      # around_perform do |_job, block|
      #   begin
      #     performed_job.running!
      #     block.call ? performed_job.success! : performed_job.error!
      #   rescue StandardError => e
      #     performed_job.error!
      #     raise e
      #   ensure
      #     performed_job.increment!(:performs)
      #   end
      # end
    end

    private

    # def performed_job
    #   return if max_performs_options.blank?
    #   key = max_performs_options[:key].call(*arguments)
    #   return if key.blank?
    #   PerformedJob.where(type: max_performs_options[:type], key: key).first_or_create
    # rescue ActiveRecord::RecordNotUnique
    #   PerformedJob.find(type: max_performs_options[:type], key: key)
    # end

    # def should_enqueue?
    #   return false if performed_job.blank?
    #   return false if performed_job.enqueued? || performed_job.running? || performed_job.success?
    #   performed_job.performs < max_performs_options[:performs].to_i
    # end

    # memoize :performed_job, :should_enqueue?
  end
end
