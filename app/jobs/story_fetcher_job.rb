class StoryFetcherJob < ActiveJob::Base
  extend Memoist

  def perform(story_id)
    @story_id = story_id
    return if story.blank?

    story.fetching!
    if update
      story.ready!
    else
      story.error!
    end
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
  end

  def image_public_id
    image_url = embedly.parsed_response.images.try(:first).try(:url)
    return if image_url.blank?
    Cloudinary::Uploader.upload(image_url).try(:[], 'public_id')
  end

  def update
    update_info
    update_image
    update_social
    story.save
  end

  def update_info
    return unless story.missing_info?
    return if embedly.code != 200
    story.title = embedly.parsed_response.title
    story.description = embedly.parsed_response.description
    story.content = embedly.parsed_response.content
  end

  def update_image
    return unless story.missing_image?
    return if embedly.code != 200
    story.image_public_id = image_public_id
  end

  def update_social
    story.social = social.to_h
  end

  memoize :story, :social, :embedly, :image_public_id
end
