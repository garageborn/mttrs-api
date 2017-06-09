class Extract
  class Page
    attr_accessor :description, :html, :image, :language, :published_at, :title, :url

    def initialize(attributes = {})
      self.description = attributes[:description]
      self.html = attributes[:html]
      self.image = attributes[:image]
      self.language = attributes[:language]
      self.published_at = attributes[:published_at]
      self.title = attributes[:title]
      self.url = attributes[:url]
    end

    def blank?
      attributes.all? { |attribute| send(attribute).blank? }
    end

    def complete?
      attributes.all? { |attribute| send(attribute).present? }
    end

    def missing_attributes
      attributes.select { |attribute| send(attribute).blank? }
    end

    def merge(attrs)
      attributes.each do |attribute|
        new_value = attrs[attribute]
        next if new_value.blank?
        send("#{ attribute }=", new_value)
      end
    end

    def attributes
      %i(description html image language published_at title url)
    end
  end
end
