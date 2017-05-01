class LinkSetTagsJob
  include Sidekiq::Worker

  sidekiq_options queue: :link_set_tags, retry: false

  def perform(link_id)
    Link::SetTags.run(id: link_id)
  end
end
