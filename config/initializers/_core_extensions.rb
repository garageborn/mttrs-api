Apartment.send :extend, CoreExtensions::Apartment::TenantOptions
Apartment::Tenant.send :extend, CoreExtensions::Apartment::Tenant::CurrentOptions
Cocoon::ViewHelpers.send :prepend, CoreExtensions::Cocoon::ViewHelpers
