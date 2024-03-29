# You can have Apartment route to the appropriate Tenant by adding some Rack middleware.
# Apartment can support many different "Elevators" that can take care of this routing to your data.
# Require whichever Elevator you're using below or none if you have a custom one.
#
# require 'apartment/elevators/generic'
# require 'apartment/elevators/domain'
# require 'apartment/elevators/subdomain'
# require 'apartment/elevators/first_subdomain'
require ::File.expand_path('../../../lib/elevator', __FILE__)
#
# Apartment Configuration
#
Apartment.configure do |config|
  config.excluded_models = %w[
    AmpLink
    AttributeMatcher
    BlockedUrl
    Link
    LinkUrl
    Publisher
    PublisherDomain
    PublisherSuggestion
    SocialCounter
    TitleReplacement
  ]

  config.tenant_names = %w[
    mttrs_us
    mttrs_br
    mttrs_ar
    mttrs_cl
    mttrs_mx
    mttrs_pt
    mttrs_us_es
    mttrs_au
    mttrs_ca
    mttrs_de
    mttrs_es
    mttrs_uk
  ]

  config.tenant_options = {
    mttrs_us: { country: 'United States', languages: %w[en], default_timezone: 'EST' },
    mttrs_br: { country: 'Brasil', languages: %w[pt], default_timezone: 'Brasilia' },
    mttrs_ar: { country: 'Argentina', languages: %w[es], default_timezone: 'Buenos Aires' },
    mttrs_cl: { country: 'Chile', languages: %w[es], default_timezone: 'Santiago' },
    mttrs_mx: { country: 'Mexico', languages: %w[es], default_timezone: 'Mexico City' },
    mttrs_pt: { country: 'Portugal', languages: %w[pt], default_timezone: 'Lisbon' },
    mttrs_us_es: { country: 'United States (Spanish)', languages: %w[es], default_timezone: 'EST' },
    mttrs_au: { country: 'Australia', languages: %w[en], default_timezone: 'AEDT' },
    mttrs_ca: { country: 'Canada', languages: %w[en], default_timezone: 'Ottawa' },
    mttrs_de: { country: 'Deutschland', languages: %w[de], default_timezone: 'Berlin' },
    mttrs_es: { country: 'España', languages: %w[es], default_timezone: 'Madrid' },
    mttrs_uk: { country: 'United Kingdom', languages: %w[en], default_timezone: 'UTC' },
  }

  #
  # ==> PostgreSQL only options

  # Specifies whether to use PostgreSQL schemas or create a new database per Tenant.
  # The default behaviour is true.
  #
  # config.use_schemas = true

  # Apartment can be forced to use raw SQL dumps instead of schema.rb for creating new schemas.
  # Use this when you are using some extra features in PostgreSQL that can't be respresented in
  # schema.rb, like materialized views etc. (only applies with use_schemas set to true).
  # (Note: this option doesn't use db/structure.sql, it creates SQL dump by executing pg_dump)
  #
  # config.use_sql = false

  # There are cases where you might want some schemas to always be in your search_path
  # e.g when using a PostgreSQL extension like hstore.
  # Any schemas added here will be available along with your selected Tenant.
  #
  config.persistent_schemas = %w[shared_extensions]

  # <== PostgreSQL only options
  #

  # By default, and only when not using PostgreSQL schemas, Apartment will prepend the environment
  # to the tenant name to ensure there is no conflict between your environments.
  # This is mainly for the benefit of your development and test environments.
  # Uncomment the line below if you want to disable this behaviour in production.
  #
  # config.prepend_environment = !Rails.env.production?
end

# Setup a custom Tenant switching middleware. The Proc should return the name of the Tenant that
# you want to switch to.
# Rails.application.config.middleware.use 'Apartment::Elevators::Generic', lambda { |request|
#   request.host.split('.').first
# }

# Rails.application.config.middleware.use 'Apartment::Elevators::Domain'
# Rails.application.config.middleware.use 'Apartment::Elevators::Subdomain'
# Rails.application.config.middleware.use 'Apartment::Elevators::FirstSubdomain'
Rails.application.config.middleware.use Elevator

# tenant shortcuts
Apartment.tenant_names.each do |tenant_name|
  tenant = tenant_name.to_sym
  options = Apartment.tenant_options[tenant]

  define_method("#{ tenant }!") do
    Time.zone = options[:default_timezone]
    Apartment::Tenant.switch!(tenant)
  end
end
