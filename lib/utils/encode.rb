module Utils
  class Encode
    RESCUE_FROM = [
      Encoding::InvalidByteSequenceError,
      Encoding::UndefinedConversionError
    ].freeze

    class << self
      def run(string)
        string.to_s.force_encoding('UTF-8')
      rescue *RESCUE_FROM
        string        
      end
    end
  end
end
