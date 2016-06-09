module Social
  class Counters
    attr_accessor :facebook, :google_plus, :linkedin, :pinterest, :twitter

    def initialize(attributes = {})
      self.facebook ||= attributes[:facebook].to_i
      self.google_plus ||= attributes[:google_plus].to_i
      self.linkedin ||= attributes[:linkedin].to_i
      self.pinterest ||= attributes[:pinterest].to_i
      self.twitter ||= attributes[:twitter].to_i
    end

    def blank?
      attributes.all? { |attribute| send(attribute).zero? }
    end

    def attributes
      %i(facebook google_plus linkedin pinterest twitter)
    end

    def to_h
      Hash[attributes.map { |attribute| [attribute, send(attribute)] }]
    end
  end
end
