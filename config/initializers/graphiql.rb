GraphiQL::Rails.config.headers['X-Tenant'] = lambda { |context|
  Apartment::Tenant.current
}
