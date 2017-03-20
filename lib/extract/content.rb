require 'readability'

class Extract
  class Content < Base
    attr_reader :content

    def value
      readability = Readability::Document.new(document, tags: [], remove_empty_nodes: true)
      @content = readability.content

      return if content.blank?
      encode!
      strip!
      content
    end

    private

    def encode!
      @content = Utils::Encode.run(content)
    end

    def strip!
      @content = Utils::StripAttributes.run(content)
    end
  end
end
