require 'apartment/elevators/generic'

class Elevator < Apartment::Elevators::Generic
  def parse_tenant_name(request)
    header_tenant(request) || path_tenant(request) || default_tenant
  end

  private

  def default_tenant
    Apartment.tenant_names.first
  end

  def header_tenant(request)
    Apartment.tenant_names.find do |tenant_name|
      tenant_name.downcase == request.env['HTTP_X_TENANT']
    end
  end

  def path_tenant(request)
    # todo
  end
end
