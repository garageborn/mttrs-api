require 'reform/form/validation/unique_validator'

class Feed
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = { page: 1, per: 20 }.freeze

    def model!(params)
      ::Feed.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Form < Trailblazer::Operation
    include Callback
    include Model
    model Feed

    contract do
      include Reform::Form::ModelReflections
      property :publisher_id
      property :category_id
      property :url
      validates :publisher_id, :category_id, presence: true
      validates :url, presence: true, unique: { case_sensitive: false }

      def prepopulate!(options)
        self.publisher_id ||= options[:params][:publisher_id]
        self.category_id ||= options[:params][:category_id]
      end
    end

    callback :after_save do
      on_change :enqueue_feed_fetcher
    end

    def process(params)
      validate(params[:feed]) do
        contract.save
        callback!(:after_save)
      end
    end

    private

    def enqueue_feed_fetcher(*)
      FeedFetcherJob.perform_later(model.id)
    end
  end

  class Create < Form
    action :create
  end

  class Update < Create
    action :update
  end

  class Destroy < Trailblazer::Operation
    include Model
    model Feed, :find

    def process(*)
      model.destroy
      model.links.clear
    end
  end
end
