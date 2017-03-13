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

  attr_reader :base_link, :links
  def_delegators :@links, :each, :each_with_index, :map, :first, :last

  def initialize(base_link)
    @base_link = base_link
    @links = []
  end

  def add(record, hit)
    return unless valid_record?(record)
    similar_link = links.detect { |link| link.id == record.id }
    return similar_link.merge(record, hit) if similar_link
    links.push(SimilarLink.new(record, hit))
  end

  def merge(records)
    records.each_with_hit { |record, hit| add(record, hit) }
  end

  private

  def valid_record?(record)
    record.belongs_to_current_tenant? && record.category == base_link.category
  end
end
