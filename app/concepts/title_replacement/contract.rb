class TitleReplacement
  class Contract < Reform::Form
    property :matcher
    validates :matcher, presence: true
  end
end
