class Publisher
  class Contract < Reform::Form
    property :domain
    property :icon_id, populator: :icon_id!
    property :language
    property :name
    property :slug

    validates :domain, presence: true, unique: { case_sensitive: false }
    validates :language, presence: true, inclusion: { in: Utils::Language::AVAILABLE_LANGUAGES }
    validates :name, presence: true, unique: { case_sensitive: false }

    private

    def icon_id!(options)
      self.icon_id = CloudinaryPopulator.call(options[:doc][:icon_id])
    end
  end
end
