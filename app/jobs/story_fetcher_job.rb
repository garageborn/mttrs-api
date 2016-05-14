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
    return if embedly.code != 200

    story.update_attributes(
      social: social.to_h,
      title: embedly.parsed_response.title,
      description: embedly.parsed_response.description,
      content: embedly.parsed_response.content,
      image_public_id: image_public_id
    )
  end

  memoize :story, :social, :embedly, :image_public_id
end
