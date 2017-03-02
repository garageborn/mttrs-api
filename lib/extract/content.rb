require 'readability'

module Extract
  class Content < Base
    def value
      readability = Readability::Document.new(document, tags: [], remove_empty_nodes: true)
<<<<<<< Updated upstream
      return readability.content unless readability.content.blank?
=======
      return Utils::StripAttributes.run(readability.content) unless readability.content.blank?
>>>>>>> Stashed changes
    end
  end
end
