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
        new_string = transcode(string.to_s.dup).force_encoding(Encoding::UTF_8)
        new_string.valid_encoding? ? new_string : string
      rescue *RESCUE_FROM
        string
      end

      def transcode(string)
        return string if string.blank? || string.encoding == Encoding::UTF_8
        detection = CharlockHolmes::EncodingDetector.detect(string)
        return string if detection.try(:[], :encoding).blank?
        CharlockHolmes::Converter.convert(string, detection[:encoding], Encoding::UTF_8.to_s)
      end
    end
  end
end
