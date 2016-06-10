module Extract
  module Strategies
    module Parser
      class Base
        attr_reader :document

        def initialize(document)
          @document = document
        end

        def meta_value(key)
          tags = document.css("meta[#{ key }]")
          return if tags.none?
          tags.first.attributes.try(:[], 'content').try(:value)
        end

        def tag_value(name)
          tags = document.css(name)
          return if tags.none?
          tags.text
        end
      end
    end
  end
end
