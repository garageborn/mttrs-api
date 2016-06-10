module Extract
  class Page
    attr_accessor :content, :description, :html, :image, :title

    def initialize(attributes = {})
      self.content = attributes[:content]
      self.description = attributes[:description]
      self.html = attributes[:html]
      self.image = attributes[:image]
      self.title = attributes[:title]
    end

    def blank?
      attributes.all? { |attribute| send(attribute).blank? }
    end

    def complete?
      attributes.all? { |attribute| send(attribute).present? }
    end

    def merge(page)
      attributes.each do |attribute|
        next if send(attribute).present?
        send("#{ attribute }=", page.send(attribute))
      end
    end

    def attributes
      %i(content description html image title)
    end
  end
end
