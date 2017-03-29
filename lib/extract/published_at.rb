class Extract
  class PublishedAt < Base
    extend Memoist

    def value
      return if published_at.blank?
      translate_date!
      Date.parse(published_at)
    rescue ArgumentError
    end

    private

    def published_at
      matcher_value(:published_at)
    end

    def translate_date!
      locales = I18n.available_locales - [:en]
      locales.each { |locale| translate_string(locale) }
    end

    def translate_string(locale)
      keys = %w(date.abbr_day_names date.abbr_month_names date.day_names date.month_names)
      keys.each { |key| translate_key(key, locale) }
    end

    def translate_key(key, locale)
      translated_key = I18n.translate(key, locale: locale)
      default_key = I18n.translate(key, locale: :en)

      translated_key.each_with_index do |value, index|
        default_value = default_key[index]
        next if value.blank? || default_value.blank?
        regex = /#{ value }\b+/i
        published_at.gsub!(regex, default_value)
      end
    end

    memoize :published_at
  end
end
