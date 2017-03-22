class FullFetchLinkJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :link_full_fetch
  attr_reader :link_id
  delegate :publisher, to: :link

  def perform(link_id)
    @link_id = link_id
    return if link.blank? || !link.missing_html?

    set_missing_info
    link.save
    Link::SetCategory.run(id: link.id)
    Link::UpdateStory.run(id: link.id)
    StoryBuilderJob.perform_async(link.id)
  end

  private

  def link
    Link.find_by(id: link_id)
  end

  def set_missing_info
    return if page.blank?
    set_image_source_url
    %i(content description html language published_at title).each do |attribute|
      merge_attribute(attribute)
    end
  end

  def set_image_source_url
    return if publisher.blocked_urls.match?(page.image)
    link.image_source_url = page.image
  end

  def merge_attribute(attribute)
    new_value = page.send(attribute)
    return if new_value.blank?
    link[attribute] = page.send(attribute)
  end

  def page
    current_page = Extract::Page.new(
      content: link.content,
      description: link.description,
      html: link.html,
      image: link.image_source_url,
      language: link.language || publisher.language,
      published_at: link.published_at,
      title: link.title,
      url: link.uri
    )
    Extract.run(current_page, publisher: publisher, force_attributes: %i(published_at))
  end

  memoize :link, :page
end
