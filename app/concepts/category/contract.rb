class Category
  class Contract < Reform::Form
    property :color
    property :image_id, populator: :image_id!
    property :name
    property :order

    validates :name, presence: true, unique: { case_sensitive: false }

    private

    def image_id!(options)
      self.image_id = CloudinaryPopulator.call(options[:doc][:image_id])
    end
  end
end
