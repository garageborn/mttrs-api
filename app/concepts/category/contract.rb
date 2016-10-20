class Category
  class Contract < Reform::Form
    property :color
    property :icon_id, populator: :icon_id!
    property :name
    property :order

    validates :name, presence: true, unique: { case_sensitive: false }

    private

    def icon_id!(options)
      self.icon_id = CloudinaryPopulator.call(options[:doc][:icon_id])
    end
  end
end
