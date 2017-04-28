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
  end

  attr_reader :base_link, :blocked_links, :category, :includes, :similar_links, :options
  def_delegators :@links, :each, :each_with_index, :map, :first, :last

  def initialize(options = {})
    @options = options.dup
    @base_link = @options.delete(:base_link)
    @similar_links = []
    @blocked_links = []
    @includes = %i(category category_link) + @options.delete(:includes).to_a
    @category = @options.delete(:category) || base_link.try(:category)
    perform
  end

  def add(record, hit)
    return if similar_links.detect { |similar_link| similar_link.record.id == record.id }
    return unless valid_record?(record)
    similar_links.push(SimilarLink.new(record, hit))
    add_blocked_links(record)
  end

  def perform
    return if base_link.blank?
    add_blocked_links(base_link)
    process_similars(base_link)
    links.each { |link| process_similars(link) }
  end

  def process_similars(link)
    response = link.find_similar(options)
    ::Link.where(id: map_result_ids(response)).includes(includes).each do |similar_link|
      hit = response.detect { |r| r.id.to_i == similar_link.id.to_i }
      add(similar_link, hit)
    end
  end

  def links
    similar_links.map(&:record)
  end

  def stories
    links.map(&:story)
  end

  def by_score
    similar_links.sort_by { |similar_link| -similar_link.score }
  end

  def current_link_ids
    links.map(&:id)
  end

  private

  def valid_record?(record)
    return false if blocked_story_link?(record)
    record.belongs_to_current_tenant? && valid_category?(record)
  end

  def valid_category?(record)
    record.category == category
  end

  def blocked_story_link?(record)
    return true if blocked_links.include?(record.id)
    record_blocked_links = record.blocked_links.pluck(:id)
    similar_links.any? { |similar_link| record_blocked_links.include?(similar_link.record.id) }
  end

  def map_result_ids(response)
    response.records.ids.select do |id|
      current_link_ids.exclude?(id.to_i) && blocked_links.exclude?(id.to_i)
    end
  end

  def add_blocked_links(link)
    return if link.blank?
    base_story_blocked_links = link.try(:story).try(:blocked_links).to_a.map(&:id)
    base_link_blocked_links = link.blocked_links.map(&:id)
    blocked_link_ids = (base_story_blocked_links + base_link_blocked_links).flatten.compact.uniq
    blocked_links.concat(blocked_link_ids).uniq!
  end
end
