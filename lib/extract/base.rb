class Extract
  class Base
    attr_reader :document, :publisher

    def initialize(document, options = {})
      @document = document
      @publisher = options.delete(:publisher)
    end

    def meta_value(key)
      tags = document.css("meta[#{ key }]")
      return if tags.none?
      tags.first.attributes.try(:[], 'content').try(:value)
    end

    def tag_value(name)
      method = name.start_with?('//') ? :xpath : :css
      tags = document.send(method, name)

      return if tags.none?
      Utils::StripAttributes.run(tags.text)
    end

    def matcher_value(name)
      attribute_matchers = publisher.attribute_matchers.send(name).to_a
      return if attribute_matchers.blank?

      attribute_matchers.each do |attribute_matcher|
        value = tag_value(attribute_matcher.matcher)
        return value if value.present?
      end

      nil
    end
  end
end
