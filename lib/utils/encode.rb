# References:
# https://github.com/qhwa/string_utf8/blob/master/lib/string/utf8.rb
# http://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/
module Utils
  class Encode
    RESCUE_FROM = [
      Encoding::InvalidByteSequenceError,
      Encoding::UndefinedConversionError
    ].freeze

    ENCODINGS = %w(
      iso-8859-1
      ascii-8bit
      utf-8
      ucs-bom
      shift-jis
      gb18030
      gbk
      gb2312
      cp936
    ).freeze

    class << self
      def run(string)
        new_string = encode!(string.dup).force_encoding('UTF-8')
        new_string.valid_encoding? ? new_string : string
      rescue *RESCUE_FROM
        string
      end

      def encode!(string)
        ENCODINGS.find do |encoding|
          begin
            string.encode!('utf-8', encoding)
            return string if string.valid_encoding?
          rescue *RESCUE_FROM
          end
        end
      end
    end
  end
end
