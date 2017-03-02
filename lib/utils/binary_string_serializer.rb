require 'zlib'

module Utils
  class BinaryStringSerializer
    class << self
      def dump(string)
        return if string.blank?
        Zlib::Deflate.deflate(string)
      end

      def load(string)
        return if string.blank?
        Utils::Encode.run(Zlib::Inflate.inflate(string))
      end
    end
  end
end
