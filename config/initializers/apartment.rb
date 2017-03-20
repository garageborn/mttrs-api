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
  config.excluded_models = %w(
    AttributeMatcher
    BlockedUrl
    Link
    LinkUrl
    Publisher
    PublisherDomain
    PublisherSuggestion
    SocialCounter
    TitleReplacement
  )

  config.tenant_names = %w(mttrs_us mttrs_br)
  config.tenant_options = {
    mttrs_us: { languages: %w(en) },
    mttrs_br: { languages: %w(pt) }
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
  config.persistent_schemas = %w(shared_extensions)

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
