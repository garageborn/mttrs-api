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
    @blocked_links = base_link.blocked_story_links.pluck(:link_id)
    @includes = %i(category category_link) + options.delete(:includes).to_a
    @options = options
    perform
  end

  def add(record, hit)
    return if links.detect { |link| link.id == record.id }
    return unless valid_record?(record)
    links.push(SimilarLink.new(record, hit))
    blocked_links.concat(record.blocked_story_links.pluck(:link_id))
    revalidate!
  end

  def by_score
    links.sort_by { |link| -link.score }
  end

  def perform
    process_similars(base_link)
    each { |link| process_similars(link) }
  end

  def process_similars(link)
    find_similar = link.find_similar(options)
    current_link_ids = links.map(&:id)
    result_ids = find_similar.records.ids.select { |id| current_link_ids.exclude?(id.to_i) }

    ::Link.where(id: result_ids).includes(includes).each do |similar_link|
      hit = find_similar.detect { |r| r.id.to_i == similar_link.id.to_i }
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
    blocked_links.include?(record.id)
  end

  def revalidate!
    links.delete_if { |record| !valid_record?(record) }
  end
end
