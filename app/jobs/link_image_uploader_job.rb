class LinkImageUploaderJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :link_image_uploader, retry: false
  attr_reader :link_id

  def perform(link_id)
    @link_id = link_id
    return if link.blank? || link.image.present?
    link.image = URI.parse(link.image_source_url) rescue nil
    link.save
  end

  def link
    Link.find_by(id: link_id)
  end

  memoize :link
end
