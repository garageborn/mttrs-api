# reference: https://robots.thoughtbot.com/fight-back-utf-8-invalid-byte-sequences
module Utils
  class Encode
    def self.run(string)
      new_string = string.to_s.dup
      return if new_string.blank?

      new_string.encode(
        'UTF-8',
        'binary',
        invalid: :replace,
        undef: :replace,
        replace: ''
      ).force_encoding('UTF-8')
    end
  end
end
