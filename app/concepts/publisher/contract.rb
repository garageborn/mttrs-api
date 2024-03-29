class Publisher
  class Contract < Reform::Form
    include Concerns::HasNestedForm

    property :icon
    property :language
    property :name
    property :display_name
    property :restrict_content

    has_nested_form :blocked_urls, form: BlockedUrl::Contract, klass: BlockedUrl
    has_nested_form :publisher_domains,
                    form: PublisherDomain::Contract,
                    klass: PublisherDomain,
                    prepopulate: true
    has_nested_form :title_replacements,
                    form: TitleReplacement::Contract,
                    klass: TitleReplacement,
                    prepopulate: false
    has_nested_form :attribute_matchers,
                    form: AttributeMatcher::Contract,
                    klass: AttributeMatcher,
                    prepopulate: false

    validates :icon, presence: true
    validates :language, presence: true, inclusion: { in: Utils::Language::AVAILABLE_LANGUAGES }
    validates :name, presence: true, unique: { case_sensitive: false }
  end
end
