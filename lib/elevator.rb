require 'apartment/elevators/generic'

class Elevator < Apartment::Elevators::Generic
  def parse_tenant_name(request)
    header_tenant(request.env['X-Tenant']) || path_tenant(request.path) || default_tenant
  end

  private

  def default_tenant
    Apartment.tenant_names.first
  end

  def header_tenant(header)
    Apartment.tenant_names.find { |tenant_name| tenant_name.downcase == header }
  end

  def path_tenant(path)
    # todo
  end
end
