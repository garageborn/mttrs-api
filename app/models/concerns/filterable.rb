# Call scopes directly from your URL params:
#
# @products = Product.filter(params.slice(:status, :location, :starts_with))
module Concerns
  module Filterable
    extend ActiveSupport::Concern

    module ClassMethods
      # Call the class methods with the same name as the keys in <tt>filtering_params</tt>
      # with their associated values. Most useful for calling named scopes from
      # URL params. Make sure you don't pass stuff directly from the web without
      # whitelisting only the params you care about first!
      def filter(filtering_params)
        results = where(nil) # create an anonymous scope
        filtering_params.each do |key, value|
          next if value.blank?
          begin
            results = results.public_send(key, value)
          rescue ArgumentError # if we have a scope with arity 0 or enum query
            results = results.public_send(key)
          end
        end
        results
      end
    end
  end
end
