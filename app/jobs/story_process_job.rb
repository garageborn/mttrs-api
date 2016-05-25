class StoryProcessJob < ActiveJob::Base
  extend Memoist

  def perform(options)
    @options = options
    return if options.blank? || feed.blank?
    return add_feed if Story.where(source_url: options[:url]).exists?

    set_url
    return if Story.where(url: story.url).where.not(id: story.id).exists?

    add_feed
    set_missing_info
    set_image
    set_content
    enqueue_social_counter_update if story.save
  end

  private

  def options
    @options
  end

  def story
    Story.where(source_url: options[:url]).first_or_initialize.tap do |story|
      story.title ||= options[:title]
      story.description ||= options[:description]
    end
  end

  def feed
    Feed.find_by_id(options[:feed_id])
  end

  def set_url
    head = HTTParty.head(options[:url], headers: { 'User-Agent' => '' }, verify: false)
    if head.success?
      story.url = head.request.last_uri.to_s
    else
      story.url = options[:url]
    end
  rescue HTTParty::Error
    story.url = options[:url]
  end

  def set_missing_info
    return unless story.missing_info?
    return unless embedly.success?
    story.url = embedly.url
    story.title = embedly.parsed_response.title
    story.description = embedly.parsed_response.description
  end

  def set_image
    return unless story.missing_image?
    return if image_source_url.blank?
    story.image_source_url = image_source_url
  end

  def set_content
    return unless story.missing_content?
    story.content = embedly.parsed_response.content
  end

  def add_feed
    return if story.feeds.include?(feed)
    story.feeds << feed
    story.publisher ||= feed.publisher
  end

  def embedly
    Embedly.extract(story.url)
  rescue StandardError
  end

  def image_source_url
    return options[:image] if options[:image].present?
    return unless embedly.success?
    embedly.parsed_response.images.try(:first).try(:url)
  end

  def enqueue_social_counter_update
    SocialCounterUpdateJob.perform_later(story.id)
  end

  memoize :options, :story, :feed, :embedly, :image_source_url
end
