module Utils
  class Encode
    RESCUE_FROM = [
      Encoding::InvalidByteSequenceError,
      Encoding::UndefinedConversionError
    ].freeze

    class << self
      def run(string)
        new_string = string.dup.to_s.force_encoding('UTF-8')
        new_string.valid_encoding? ? new_string : string
      rescue *RESCUE_FROM
        string        
      end
    end
  end
end
