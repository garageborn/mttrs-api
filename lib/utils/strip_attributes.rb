module Utils
  class StripAttributes
    REPLACEMENTS = {
      /[\r\n\t]+/ => '',
      '  ' => ' ',
      '&amp;' => '&',
      /[”“]+/ => '"',
      /&#\d+;/ => '',
      /[^[:print:]]/ => ''
    }.freeze

    def self.run(string)
      return if string.blank?
      new_string = Utils::Encode.run(string)
      new_value = ActionView::Base.full_sanitizer.sanitize(new_string) # default rails sanitizer
      REPLACEMENTS.each { |regexp, replacement_value| new_value.gsub!(regexp, replacement_value) }
      new_value = new_value.split.join(' ').squish # remove double spaces
      new_value.strip
    end
  end
end
