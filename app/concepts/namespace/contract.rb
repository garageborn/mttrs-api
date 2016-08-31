class Namespace
  class Contract < Reform::Form
    include Reform::Form::ModelReflections

    property :slug
    validates :slug, presence: true, unique: { case_sensitive: false }
  end
end
