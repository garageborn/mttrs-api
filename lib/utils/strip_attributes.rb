module Utils
  class StripAttributes
    REPLACEMENTS = {
      /[\r\n\t]+/ => '',
      '  ' => ' ',
      '&amp;' => '&',
      /[”“]+/ => '"',
      /&#\d+;/ => ''
    }.freeze

    def self.run(string)
      new_value = ActionView::Base.full_sanitizer.sanitize(string.to_s) # default rails sanitizer
      REPLACEMENTS.each { |regexp, replacement_value| new_value.gsub!(regexp, replacement_value) }
      new_value = new_value.split.join(' ').squish # remove double spaces
      new_value.gsub!(/[^[:print:]]/ , '') # excludes control characters and similar
      new_value.strip
    end
  end
end
