class BlockedUrl < ApplicationRecord
  extend Memoist

  belongs_to :publisher

  def self.match?(strings)
    strings = strings.to_a.flatten.compact.uniq
    self.all.detect do |blocked_url|
      strings.detect { |string| blocked_url.match?(string) }
    end
  end

  def regexp
    return if matcher.blank?
    Regexp.new(matcher, Regexp::IGNORECASE)
  end

  def match?(string)
    return if matcher.blank?
    string.match(regexp).present?
  end

  memoize :regexp
end
