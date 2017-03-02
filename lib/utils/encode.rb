# reference: https://robots.thoughtbot.com/fight-back-utf-8-invalid-byte-sequences
module Utils
  class Encode
    class << self
      def run(string)
        new_string = string.to_s.dup
        return if new_string.blank?

        new_string = utf8_to_utf16(new_string)
        new_string = utf16_to_utf8(new_string)
        new_string.force_encoding('UTF-8')
      end

      private

      def utf8_to_utf16(string)
        string.encode('UTF-16', 'UTF-8')
      rescue Encoding::UndefinedConversionError
        string
      end

      def utf16_to_utf8(string)
        string.encode('UTF-8', 'UTF-16')
      rescue Encoding::UndefinedConversionError
        string
      end
    end
  end
end
