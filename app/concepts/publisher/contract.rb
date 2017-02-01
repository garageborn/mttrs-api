class Publisher
  class Contract < Reform::Form
    include Concerns::HasNestedForm

    property :icon_id, populator: :icon_id!
    property :language
    property :name
    property :slug
    has_nested_form :publisher_domains,
                    form: PublisherDomain::Contract,
                    klass: PublisherDomain,
                    prepopulate: true

    validates :icon_id, presence: true
    validates :language, presence: true, inclusion: { in: Utils::Language::AVAILABLE_LANGUAGES }
    validates :name, presence: true, unique: { case_sensitive: false }

    private

    def icon_id!(options)
      self.icon_id = CloudinaryPopulator.call(options[:doc][:icon_id])
    end
  end
end
