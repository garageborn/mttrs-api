CloudinaryHelper.send :prepend, CoreExtensions::Cloudinary::Helpers
Apartment.send :extend, CoreExtensions::Apartment::TenantOptions
Apartment::Tenant.send :extend, CoreExtensions::Apartment::Tenant::CurrentOptions
