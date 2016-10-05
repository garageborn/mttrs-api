class Category
  class Contract < Reform::Form
    property :name
    property :color
    property :icon_id, populator: :icon_id!

    validates :name, presence: true, unique: { case_sensitive: false }

    private

    def icon_id!(options)
      self.icon_id = CloudinaryPopulator.call(options[:doc][:icon_id])
    end
  end
end
