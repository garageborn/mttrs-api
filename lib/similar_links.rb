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

  attr_reader :base_link, :blocked_links, :category, :includes, :links, :options
  def_delegators :@links, :each, :each_with_index, :map, :first, :last

  def initialize(options = {})
    @options = options.dup
    @base_link = @options.delete(:base_link)
    @links = []
    @blocked_links = []
    @includes = %i(category category_link) + @options.delete(:includes).to_a
    @category = @options.delete(:category) || base_link.try(:category)
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
    return unless base_link.present?
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
    record.category == category
  end

  def blocked_story_link?(record)
    return true if blocked_links.include?(record.id)
    record_blocked_links = record.blocked_links.pluck(:id)
    links.any? { |link| record_blocked_links.include?(link.id) }
  end

  def map_result_ids(response)
    current_link_ids = links.map(&:id)
    response.records.ids.select do |id|
      current_link_ids.exclude?(id.to_i) && blocked_links.exclude?(id.to_i)
    end
  end

  def set_blocked_links
    return unless base_link.present?
    base_story_blocked_links = base_link.try(:story).try(:blocked_links).to_a.map { |link| link.id }
    base_link_blocked_links = base_link.blocked_stories.map { |story| story.try(:link_ids).to_a }
    blocked_link_ids = (base_story_blocked_links + base_link_blocked_links).flatten.compact.uniq
    blocked_links.concat(blocked_link_ids)
  end
end
