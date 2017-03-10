class LinkCategorizerJob
  include Sidekiq::Worker

  sidekiq_options queue: :link_categorizer

  def perform(link_id)
    Link::SetCategory.run(id: link_id)
  end
end
