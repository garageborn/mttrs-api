require 'zlib'

module Utils
  class BinaryStringSerializer
    class << self
      def dump(string)
        return unless string
        Zlib::Deflate.deflate(Utils::Encode.run(string))
      end

      def load(string)
        return unless string
        Utils::Encode.run(Zlib::Inflate.inflate(string))
      end
    end
  end
end
