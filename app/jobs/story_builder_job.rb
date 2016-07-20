class StoryBuilderJob < ActiveJob::Base
  extend Memoist
  include Concerns::MaxPerforms

  queue_as :story_builder
  max_performs 2, key: proc { |link_id| link_id }
  attr_reader :link_id

  def perform(link_id)
    @link_id = link_id
    return if link.blank? || !link.missing_story?

    if similar.blank?
      story.links << link
    else
      similar.each do |similar|
        next if similar.story.present?
        story.links << similar
      end
    end

    !link.missing_story?
  end

  private

  def link
    Link.find_by_id(link_id)
  end

  def similar
    link.similar.records
  end

  def story
    return Story.create if similar.blank?
    similar.records.detect { |link| link.story.present? }.try(:story) || Story.create
  end

  memoize :link, :similar, :story
end
