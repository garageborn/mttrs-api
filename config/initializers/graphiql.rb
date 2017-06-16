GraphiQL::Rails.config.headers['X-Tenant'] = lambda { |_context|
  Apartment::Tenant.current
}
