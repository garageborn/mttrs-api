class Link
  class SetCategory < Operation
    def process(params)
      Apartment::Tenant.each do
        Link::SetCategory::Tenant.run(id: params[:id])
      end
    end

    class Tenant < Operation
      extend Memoist

      action :find

      def process(_params)
        return if model.category.present? || new_category.blank?
        model.update_attributes(category: new_category)
        StoryBuilderJob.perform_async(model.id)
      end

      private

      def new_category
        model.publisher.category_matchers.ordered.to_a.detect do |category_matcher|
          category_matcher.match?(model)
        end.try(:category)
      end

      memoize :new_category
    end
  end
end
