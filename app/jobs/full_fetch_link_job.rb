class FullFetchLinkJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :link_id

  def perform(link_id)
    @link_id = link_id
    # return if link.blank? || !link.needs_full_fetch?

    set_missing_info
    link.save
    Link::AddCategories.run(id: link.id)
  end

  private

  def link
    Link.find_by(id: link_id)
  end

  def set_missing_info
    return if page.blank?
    set_image_source_url
    %i(content description language html title).each do |attribute|
      merge_attribute(attribute)
    end
  end

  def set_image_source_url
    return if link.publisher.blocked_urls.match?(page.image)
    link.image_source_url = page.image
  end

  def merge_attribute(attribute)
    link[attribute] = page.send(attribute) if link[attribute].blank?
  end

  def page
    current_page = Extract::Page.new(
      content: link.content,
      description: link.description,
      image: link.image_source_url,
      language: link.language || link.feeds.first.try(:language),
      html: link.html,
      title: link.title,
      url: link.uri
    )
    Extract.run(current_page)
  end

  memoize :link, :page
end
