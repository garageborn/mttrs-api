# references
# - http://stackoverflow.com/questions/2982677/ruby-1-9-invalid-byte-sequence-in-utf-8
# - https://robots.thoughtbot.com/fight-back-utf-8-invalid-byte-sequences
module Utils
  class Encode
    RESCUE_FROM = [
      Encoding::InvalidByteSequenceError,
      Encoding::UndefinedConversionError
    ].freeze

    class << self
      def run(string)
        new_string = string.dup
        return unless new_string

        new_string = utf8_to_utf16(new_string)
        new_string = utf16_to_utf8(new_string)
        new_string.force_encoding('UTF-8')
      end

      private

      def utf8_to_utf16(string)
        string.encode('UTF-16', 'UTF-8')
      rescue *RESCUE_FROM
        string
      end

      def utf16_to_utf8(string)
        string.encode('UTF-8', 'UTF-16')
      rescue *RESCUE_FROM
        string
      end
    end
  end
end
