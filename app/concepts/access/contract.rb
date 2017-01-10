class Access
  class Contract < Reform::Form
    property :accessable_type
    property :accessable_id
    property :date
    validates :accessable_type, :accessable_id, :date, presence: true
  end
end
