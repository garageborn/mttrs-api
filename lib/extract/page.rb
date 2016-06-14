module Extract
  class Page
    attr_accessor :content, :description, :html, :image, :title, :url

    def initialize(attributes = {})
      self.content = attributes[:content]
      self.description = attributes[:description]
      self.html = attributes[:html]
      self.image = attributes[:image]
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
        next if send(attribute).present?
        send("#{ attribute }=", attrs[attribute])
      end
    end

    def attributes
      %i(content description html image title url)
    end
  end
end
