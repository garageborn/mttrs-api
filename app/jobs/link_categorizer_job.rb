class LinkCategorizerJob
  include Sidekiq::Worker

  def perform(link_id)
    Link::SetCategory.run(id: link_id)
  end
end
