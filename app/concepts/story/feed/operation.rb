class Feed
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = { page: 1, per: 20, order_by_links_count: true }.freeze

    def model!(params)
      ::Feed.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page).to_h)
    end
  end

  class Form < Trailblazer::Operation
    include Callback
    include Model
    model Feed
    contract Contract

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
      FeedFetcherJob.perform_async(model.id)
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
      model.namespaces.clear
    end
  end
end
