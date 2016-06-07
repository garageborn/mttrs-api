class SocialCounterFetcherJob < ActiveJob::Base
  extend Memoist
  attr_reader :story_id

  def perform(story_id)
    @story_id = story_id
    return if story.blank? || entry.blank?
    enqueue_social_counter_update
  end

  private

  def story
    Story.find_by_id(story_id)
  end

  def entries
    query = { q: story.url, num_results: 1 }
    response = Buzzsumo.articles(query: query)
    return if response.parsed_response.blank?
    response.parsed_response.results.to_a
  end

  def entry
    entries.find do |entry|
      [story.url, story.source_url].include?(entry[:url])
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

  memoize :story, :entries, :entry
end
