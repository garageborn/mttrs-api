class FullFetchStoryJob < ActiveJob::Base
  extend Memoist
  attr_reader :story_id

  def perform(story_id)
    @story_id = story_id
    return if story.blank? || !story.needs_full_fetch?

    set_missing_info
    story.save
  end

  private

  def story
    Story.find_by_id(story_id)
  end

  def set_missing_info
    return if page.blank?
    story.content ||= page.content
    story.description ||= page.description
    story.image_source_url ||= page.image
    story.html ||= page.html
    story.title ||= page.title
  end

  def page
    current_page = Extract::Page.new(
      content: story.content,
      description: story.description,
      image: story.image_source_url,
      html: story.html,
      title: story.title,
      url: story.url
    )
    Extract.run(current_page)
  end

  memoize :story, :page
end
