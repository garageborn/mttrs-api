module Concerns
  module TenantLink
    extend ActiveSupport::Concern
    extend Memoist

    included do |base|
      base.include Concerns::TenantOptions

      scope :available_on_current_tenant, -> { with_tenant_language }
      scope :with_tenant_language, lambda {
        current_tenant_languages.blank? ? all : where(language: current_tenant_languages)
      }
    end

    def belongs_to_current_tenant?
      belongs_to_tenant?(Apartment::Tenant.current)
    end

    def available_on_current_tenant?
      available_on_tenant?(Apartment::Tenant.current)
    end

    def belongs_to_tenant?(tenant_name)
      return if new_record?
      match_tenant_language?(tenant_name) && match_category_link?(tenant_name)
    end

    def available_on_tenant?(tenant_name)
      return if new_record?
      match_tenant_language?(tenant_name)
    end

    private

    def match_category_link?(tenant_name)
      Apartment::Tenant.switch(tenant_name) do
        CategoryLink.where(link_id: id).exists?
      end
    end

    def match_tenant_language?(tenant_name)
      languages = Apartment.tenant_options[tenant_name].try(:[], :languages) || []
      languages.include?(language)
    end

    memoize :belongs_to_tenant?
  end
end
