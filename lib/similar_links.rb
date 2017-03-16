class SimilarLinks
  extend Forwardable

  class SimilarLink
    attr_accessor :hit, :record

    def initialize(record, hit)
      @hit = hit
      @record = record
    end

    def score
      hit._score
    end

    def method_missing(method, *args)
      return record.send(method, *args) if record.respond_to?(method)
      super
    end
  end

  attr_reader :base_link, :blocked_links, :includes, :links, :options
  def_delegators :@links, :each, :each_with_index, :map, :first, :last

  def initialize(base_link, options = {})
    @base_link = base_link
    @links = []
    @blocked_links = []
    @includes = %i(category category_link) + options.delete(:includes).to_a
    @options = options
    perform
  end

  def add(record, hit)
    return if links.detect { |link| link.id == record.id }
    return unless valid_record?(record)
    links.push(SimilarLink.new(record, hit))
  end

  def by_score
    links.sort_by { |link| -link.score }
  end

  def perform
    set_blocked_links
    process_similars(base_link)
    each { |link| process_similars(link) }
  end

  def process_similars(link)
    response = link.find_similar(options)

    ::Link.where(id: map_result_ids(response)).includes(includes).each do |similar_link|
      hit = response.detect { |r| r.id.to_i == similar_link.id.to_i }
      add(similar_link, hit)
    end
  end

  private

  def valid_record?(record)
    return false if blocked_story_link?(record)
    record.belongs_to_current_tenant? && valid_category?(record)
  end

  def valid_category?(record)
    record.category == base_link.category
  end

  def blocked_story_link?(record)
    return true if blocked_links.include?(record.id)

    record_blocked_links = record.blocked_story_links.map(&:story).map do |story|
      story.try(:link_ids)
    end.flatten.compact.uniq

    links.map(&:id).any? { |id| record_blocked_links.include?(id) }
  end

  def map_result_ids(response)
    current_link_ids = links.map(&:id)
    result_ids = response.records.ids.select do |id|
      current_link_ids.exclude?(id.to_i) && blocked_links.exclude?(id.to_i)
    end
  end

  def set_blocked_links
    base_story_blocked_links = base_link.try(:story).try(:blocked_story_links).map(&:link_id)

    base_link_blocked_links = base_link.blocked_story_links.map(&:story).map do |story|
      story.try(:link_ids).to_a
    end

    blocked_link_ids = (base_story_blocked_links + base_link_blocked_links).compact.uniq

    blocked_links.concat(blocked_link_ids)
  end
end
