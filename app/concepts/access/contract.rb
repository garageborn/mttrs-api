class Access
  class Contract < Reform::Form
    property :accessable_type
    property :accessable_id
    property :created_at

    validates :accessable_type, :accessable_id, presence: true
  end
end
