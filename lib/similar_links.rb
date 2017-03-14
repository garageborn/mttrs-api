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

    def merge(_record, hit)
      @hit = hit if hit._score > @hit._score
    end

    def method_missing(method, *args)
      return record.send(method, *args) if record.respond_to?(method)
      super
    end
  end

  attr_reader :base_link, :includes, :links, :options
  def_delegators :@links, :each, :each_with_index, :map, :first, :last

  def initialize(base_link, options = {})
    @base_link = base_link
    @links = []
    @includes = %i(category category_link) + options.delete(:includes).to_a
    @options = options
    perform
  end

  def add(record, hit)
    similar_link = links.detect { |link| link.id == record.id }
    return similar_link.merge(record, hit) if similar_link
    return unless valid_record?(record)
    links.push(SimilarLink.new(record, hit))
  end

  def by_score
    links.sort_by { |link| -link.score }
  end

  def perform
    process_similars(base_link)
    each { |link| process_similars(link) }
  end

  def process_similars(link)
    result = link.find_similar(options)
    result.records.includes(includes).each do |similar_link|
      hit = result.detect { |r| r.id.to_i == similar_link.id.to_i }
      add(similar_link, hit)
    end
  end

  private

  def valid_record?(record)
    record.belongs_to_current_tenant? && record.category == base_link.category
  end
end
