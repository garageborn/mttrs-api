# reference: https://robots.thoughtbot.com/fight-back-utf-8-invalid-byte-sequences
module Utils
  class Encode
    class << self
      def run(string)
        new_string = string.to_s.dup
        return if new_string.blank?

        encode(new_string).force_encoding('UTF-8')
      end

      private

      def encode(string)
        string.encode('UTF-16', 'UTF-8', invalid: :replace, replace: '').encode('UTF-8', 'UTF-16')
      rescue Encoding::UndefinedConversionError
        string
      end
    end
  end
end
