class FullFetchLinkJob < ActiveJob::Base
  extend Memoist
  include Concerns::MaxPerforms

  attr_reader :link_id
  max_performs 2, key: proc { |link_id| link_id }

  def perform(link_id)
    @link_id = link_id
    return if link.blank? || !link.needs_full_fetch?

    set_missing_info
    link.save
    !link.needs_full_fetch?
  end

  private

  def link
    Link.find_by_id(link_id)
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
      language: link.language,
      html: link.html,
      title: link.title,
      url: link.url
    )
    Extract.run(current_page)
  end

  memoize :link, :page
end
