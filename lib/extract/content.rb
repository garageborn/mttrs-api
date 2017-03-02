require 'readability'

module Extract
  class Content < Base
    attr_reader :content

    def value
      readability = Readability::Document.new(document, tags: [], remove_empty_nodes: true)
      @content = readability.content

      return if content.blank?
      Utils::StripAttributes.run(content)
    end
  end
end
