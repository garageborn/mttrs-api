class TitleReplacement
  class Contract < Reform::Form
    include Concerns::NestedForm

    property :matcher
    validates :matcher, presence: true
  end
end
