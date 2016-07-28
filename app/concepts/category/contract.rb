require 'reform/form/validation/unique_validator'

class Category
  class Contract < Reform::Form
    property :name
    validates :name, presence: true, unique: { case_sensitive: false }
  end
end
