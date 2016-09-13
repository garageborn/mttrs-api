module Namespaced
  module Controller
    extend ActiveSupport::Concern

    included do
      before_action :set_namespace

      private

      def set_namespace
        Namespaced.current = request.headers['X-Namespace']
      end
    end
  end
end
