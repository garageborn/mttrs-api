class StoryFetcherJob < ActiveJob::Base
  extend Memoist

  def perform(story_id)
    @story_id = story_id
    return if story.blank?

    update
  end

  private

  def story
    Story.find_by_id(@story_id)
  end

  def social
    SocialShare.count(story.url)
  end

  def embedly
    Embedly.extract(story.url)
  rescue StandardError
  end

  def image_public_id
    image_url = embedly.parsed_response.images.try(:first).try(:url)
    return if image_url.blank?
    Cloudinary::Uploader.upload(image_url).try(:[], 'public_id')
  end

  def update
    story.fetching!

    update_info
    return story.destroy if Story.where(url: story.url).where.not(id: story.id).exists?
    update_image

    if story.save && !story.missing_info?
      story.ready!
      enqueue_social_fetcher
    else
      story.error!
    end
  end

  def update_info
    story.url ||= story.source_url
    return unless story.missing_info?
    return if embedly.code != 200
    story.url = embedly.url
    story.title = embedly.parsed_response.title
    story.description = embedly.parsed_response.description
    story.content = embedly.parsed_response.content
  end

  def update_image
    return unless story.missing_image?
    return if embedly.code != 200
    story.image_public_id = image_public_id
  end

  def enqueue_social_fetcher
    StorySocialFetcherJob.perform_later(story.id)
  end

  memoize :story, :social, :embedly, :image_public_id
end
