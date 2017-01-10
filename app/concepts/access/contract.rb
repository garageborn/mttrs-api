class Access
  class Contract < Reform::Form
    property :accessable_type
    property :accessable_id
    property :date
    property :hour

    validates :accessable_type, :accessable_id, :date, :hour, presence: true
  end
end
