# References:
# https://github.com/qhwa/string_utf8/blob/master/lib/string/utf8.rb
# http://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/
module Utils
  class Encode
    RESCUE_FROM = [
      Encoding::InvalidByteSequenceError,
      Encoding::UndefinedConversionError
    ].freeze

    class << self
      def run(string)
        new_string = string.dup.force_encoding('UTF-8')
        new_string.valid_encoding? ? new_string : string
      rescue *RESCUE_FROM
        string
      end
    end
  end
end
