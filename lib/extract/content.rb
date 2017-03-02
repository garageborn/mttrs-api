require 'readability'

module Extract
  class Content < Base
    def value
      readability = Readability::Document.new(document, tags: [], remove_empty_nodes: true)
      return Utils::StripAttributes.run(readability.content) unless readability.content.blank?
    end
  end
end
