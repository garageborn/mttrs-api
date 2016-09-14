class Link
  class Form < Operation
    include Callback
    include Dispatch
    contract Contract

    callback :after_save do
      on_change :enqueue_jobs
    end

    def process(params)
      validate(params[:link]) do
        contract.save
        callback!(:after_save)
      end
    end

    private

    def model!(params)
      return ::Link.find_by_id(params[:id]) if params[:id].present?
      urls = params[:link].try(:[], :urls)
      return ::Link.new(params[:link]) if urls.blank?
      ::Link.find_by_url(urls) || ::Link.new(params[:link])
    end

    def enqueue_jobs(*)
      enqueue_link_full_fetch
      enqueue_social_counter_fetcher
      enqueue_link_assigner
      enqueue_story_builder
    end

    def enqueue_link_full_fetch
      return unless model.needs_full_fetch?
      FullFetchLinkJob.perform_async(model.id)
    end

    def enqueue_social_counter_fetcher
      SocialCounterFetcherJob.perform_async(model.id)
    end

    def enqueue_link_assigner
      LinkAssignerJob.perform_async(model.id)
    end

    def enqueue_story_builder
      StoryBuilderJob.perform_async(model.id)
    end
  end
end
