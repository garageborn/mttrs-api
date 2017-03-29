class LinkSetTagsJob
  include Sidekiq::Worker

  sidekiq_options queue: :link_set_tags

  def perform(link_id)
    Link::SetTags.run(id: link_id)
  end
end
