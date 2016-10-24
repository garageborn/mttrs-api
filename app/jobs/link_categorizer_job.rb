class LinkCategorizerJob
  include Sidekiq::Worker

  def perform(link_id)
    Link::AddCategories.run(id: link_id)
  end
end
