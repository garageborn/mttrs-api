RSpec.configure do |config|
  config.before(:suite) do
    Apartment.tenant_names.each do |tenant_name|
      Apartment::Tenant.drop(tenant_name) rescue nil
    end
    Apartment::Tenant.create('mttrs_us')
  end

  config.before(:each) do
    Apartment::Tenant.switch!('mttrs_us')
  end

  config.after(:each) do
    Apartment::Tenant.reset
  end
end
