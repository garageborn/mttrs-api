module Utils
  module Language
    AVAILABLE_LANGUAGES = %w[pt en es de].freeze
    EXISTING_LANGUAGES = %w[
      af ar az be bg bn bs ca cs cy da de el en eo es esl et eu fa fi fr gl he hi hr hu id is it ja
      km kn ko lb lo lt lv mk ml mn mr ms nb ne nl nn or pa pl pt rm ro ru sk sl sq sr sv sw ta th
      tl tr tt ug uk ur uz vi wo zh
    ].freeze

    def self.find(name)
      return if name.blank?
      language = name.to_s.scan(/^[a-z]{2}/).first
      return language if language.present? && EXISTING_LANGUAGES.include?(language.downcase)
    end
  end
end
