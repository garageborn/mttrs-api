class TitleReplacement < ApplicationRecord
  extend Memoist

  belongs_to :publisher

  def self.apply(string)
    new_string = string.to_s.dup
    all.find_each do |title_replacement|
      new_string = title_replacement.apply(new_string)
    end
    new_string
  end

  def regexp
    return if matcher.blank?
    Regexp.new(matcher, Regexp::IGNORECASE)
  end

  def apply(string)
    return string if matcher.blank?
    string.gsub(regexp, '')
  end

  memoize :regexp
end
