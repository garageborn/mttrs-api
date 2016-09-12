module Namespaced
  module Controller
    extend ActiveSupport::Concern

    included do
      before_action :set_namespace

      private

      def set_namespace
        Namespaced.current = params.delete(:namespace)
      end
    end
  end
end
