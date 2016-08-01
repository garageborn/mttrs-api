require 'reform/form/validation/unique_validator'

class Proxy
  class Contract < Reform::Form
    property :ip
    property :port
    property :active
    property :requested_at

    validates :active, presence: true
    validates :ip, presence: true, unique: { scope: :port, case_sensitive: false }
    validates :port, presence: true, unique: { scope: :ip, case_sensitive: false }
  end
end
