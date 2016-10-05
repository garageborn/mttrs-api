class Publisher
  class Contract < Reform::Form
    property :name
    property :slug
    property :domain
    property :icon_id, populator: :icon_id!

    validates :name, presence: true, unique: { case_sensitive: false }
    validates :slug, presence: true, unique: { case_sensitive: false }
    validates :domain, presence: true, unique: { case_sensitive: false }

    private

    def icon_id!(options)
      self.icon_id = CloudinaryPopulator.call(options[:doc][:icon_id])
    end
  end
end
