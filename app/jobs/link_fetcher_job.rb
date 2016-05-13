class LinkFetcherJob < ActiveJob::Base
  extend Memoist

  def perform(link_id)
    @link_id = link_id
    return if link.blank?

    link.fetching!
    if update
      link.ready!
    else
      link.error!
    end
  end

  private

  def link
    Link.find_by_id(@link_id)
  end

  def social
    SocialShare.count(link.url)
  end

  def embedly
    Embedly.extract(link.url)
  end

  def image_public_id
    image_url = embedly.parsed_response.images.try(:first).try(:url)
    return if image_url.blank?
    Cloudinary::Uploader.upload(image_url).try(:[], 'public_id')
  end

  def update
    return if embedly.code != 200
    link.update_attributes(
      social: social.to_h,
      title: embedly.parsed_response.title,
      description: embedly.parsed_response.description,
      content: embedly.parsed_response.content,
      image_public_id: image_public_id
    )
  end

  memoize :link, :social, :embedly, :image_public_id
end
