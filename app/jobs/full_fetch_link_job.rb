class FullFetchLinkJob
  include Sidekiq::Worker
  extend Memoist

  attr_reader :link_id

  def perform(link_id)
    @link_id = link_id
    return if link.blank? || !link.needs_full_fetch?

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
    link.content ||= page.content
    link.description ||= page.description
    link.image_source_url ||= page.image
    link.language ||= page.language
    link.html ||= page.html
    link.title ||= page.title
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
