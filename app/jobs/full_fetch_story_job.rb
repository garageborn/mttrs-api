class FullFetchStoryJob < ActiveJob::Base
  extend Memoist
  attr_reader :story_id

  def perform(story_id)
    @story_id = story_id
    return if story.blank? || !story.needs_full_fetch?

    set_missing_info
    set_image
    set_content
    set_html
    story.save
  end

  private

  def story
    Story.find_by_id(story_id)
  end

  def set_missing_info
    byebug
    return unless story.missing_info?
    return unless embedly && embedly.success?
    story.title = embedly.parsed_response.title
    story.description = embedly.parsed_response.description
  end

  def set_image
    return unless story.missing_image?
    return unless embedly && embedly.success?
    story.image_source_url = embedly.parsed_response.images.try(:first).try(:url)
  end

  def set_content
    return unless story.missing_content?
    return unless embedly && embedly.success?
    story.content = embedly.parsed_response.content
  end

  def set_html
    return unless story.missing_html?
    return unless url_fetcher.success?
    story.html = url_fetcher.response.body
  end

  def embedly
    # return unless Rails.env.production?
    Embedly.extract(story.url)
  end

  def url_fetcher
    UrlFetcher.run(story.url)
  end

  memoize :story, :embedly, :url_fetcher
end
