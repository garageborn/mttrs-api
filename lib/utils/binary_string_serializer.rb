require 'zlib'

module Utils
  class BinaryStringSerializer
    def self.dump(string)
      return if string.blank?
      Zlib::Deflate.deflate(string)
    end

    def self.load(string)
      return if string.blank?
      Zlib::Inflate.inflate(string)
    end
  end
end
