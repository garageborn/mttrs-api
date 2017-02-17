require 'apartment/elevators/generic'

class Elevator < Apartment::Elevators::Generic
  def parse_tenant_name(request)
    header_tenant(request) || path_tenant(request) || default_tenant
  end

  private

  def default_tenant
    :mttrs_br
  end

  def header_tenant(request)
    Apartment.tenant_names.detect do |tenant_name|
      tenant_name.downcase == request.env['HTTP_X_TENANT']
    end
  end

  def path_tenant(request)
    routes = request.path.split('/')
    return unless routes.include?('admin')
    Apartment.tenant_names.detect { |tenant_name| routes.include?(tenant_name) }
  end
end
