class BuzzsumoEntryProcessJob < ActiveJob::Base
  extend Memoist
  attr_reader :entry

  def perform(entry)
    @entry = entry
    return if entry.blank? || publisher.blank? || url.blank?

    return unless story.save
    enqueue_social_counter_update
    enqueue_story_categorizer
    enqueue_story_full_fetch
  end

  private

  def publisher
    host = Addressable::URI.parse(entry[:url]).host
    Publisher.find_by_domain(PublicSuffix.domain(host))
  end

  def url
    UrlDiscovery.run(entry[:url])
  end

  def story
    Story.where(url: url).first_or_initialize.tap do |story|
      story.image_source_url ||= entry[:image_source_url]
      story.published_at ||= Time.zone.at(entry[:published_date].to_i) || Time.zone.now
      story.publisher = publisher
      story.source_url ||= entry[:url]
      story.title ||= entry[:title]
    end
  end

  def enqueue_social_counter_update
    SocialCounterUpdateJob.perform_later(
      story.id,
      facebook: entry[:total_facebook_shares],
      linkedin: entry[:linkedin_shares],
      twitter: entry[:twitter_shares],
      pinterest: entry[:pinterest_shares],
      google_plus: entry[:google_plus_shares]
    )
  end

  def enqueue_story_categorizer
    StoryCategorizerJob.perform_later(story.id)
  end

  def enqueue_story_full_fetch
    return unless story.needs_full_fetch?
    FullFetchStoryJob.perform_later(story.id)
  end

  memoize :publisher, :url, :story
end
