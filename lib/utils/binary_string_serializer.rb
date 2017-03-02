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
        Zlib::Inflate.inflate(string).force_encoding('UTF-8')
      end
    end
  end
end
