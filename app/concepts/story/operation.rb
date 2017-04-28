class Story
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = ActionController::Parameters.new(page: 1, per: 20, popular: true).freeze

    def model!(params)
      ::Story.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.
        merge(published_at: Time.zone.today).
        merge(params.permit(:category_slug, :page, :published_at, :tag_slug))
    end
  end

  class SimilarLinks < Trailblazer::Operation
    include Collection
    extend Memoist
    QUERY_OPTIONS = {
      min_score: 1,
      includes: %i(category publisher story link_url)
    }.freeze

    def model!(params)
      return if similar_links.blank?
      similar_links.links.delete_if do |similar_link|
        story.link_ids.include?(similar_link.id)
      end
      similar_links.by_score
    end

    def params!(params)
      params.permit(:id, :published_at, :query)
    end

    private

    def story
      Story.find(@params[:id])
    end

    def similar_links
      @params[:query].present? ? query_similar_links : story_similar_links
    end

    def query_similar_links
      response = ::Link.find_similar(
        query: @params[:query],
        published_at: story.published_at,
        size: 50
      )
      similar_links = ::SimilarLinks.new(QUERY_OPTIONS.merge(category: story.category))
      response.records.each { |link| similar_links.process_similars(link) }
      similar_links
    end

    def story_similar_links
      similar_links = ::SimilarLinks.new(QUERY_OPTIONS.merge(base_link: story.main_link))
      story.links.each { |link| similar_links.process_similars(link) }
      similar_links
    end

    memoize :story, :similar_links, :query_similar_links, :story_similar_links
  end

  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model Story
    contract Contract

    callback :after_update, Callbacks::AfterUpdate
  end

  class Create < Operation
    action :create

    def process(params)
      validate(params[:story]) do
        contract.save
      end
    end
  end

  class Update < Operation
    action :update

    def process(params)
      validate(params[:story]) do
        contract.save
        callback!(:after_update)
      end
    end
  end

  class Destroy < Operation
    action :find

    def process(*)
      model.destroy
    end
  end
end
