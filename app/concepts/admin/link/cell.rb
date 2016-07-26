module Admin
  module Link
    module Cell
      class SocialCounter < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper

        def social_counter
          return if social_counter.blank?
          keys = SocialCounter::PROVIDERS + [:total]
          keys.each do |key|
            value = number_with_delimiter(social_counter.read_attribute(key))
            define_method(key) { value }
          end
        end

        def show
          return if social_counter.blank?
          super
        end

        private

        def social_counter
          model.social_counter
        end
      end
    end
  end
end
