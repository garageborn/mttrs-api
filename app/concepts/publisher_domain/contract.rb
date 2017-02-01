class PublisherDomain
  class Contract < Reform::Form
    include Concerns::NestedForm

    property :domain
    validates :domain, presence: true, unique: { case_sensitive: false }
  end
end
