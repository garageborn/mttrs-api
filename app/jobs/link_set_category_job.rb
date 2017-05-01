class LinkSetCategoryJob
  include Sidekiq::Worker

  sidekiq_options queue: :link_set_category, retry: false

  def perform(link_id)
    Link::SetCategory.run(id: link_id)
  end
end
