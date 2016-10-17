class Link
  class AddCategories < Operation
    def process(params)
      Apartment::Tenant.each do
        Link::AddCategories::Tenant.run(id: params[:id])
      end
    end

    class Tenant < Operation
      extend Memoist

      action :find

      def process(_params)
        return unless new_categories?

        categories.each do |category|
          next if model.categories.include?(category)
          model.categories << category
        end

        StoryBuilderJob.perform_async(model.id)
      end

      private

      def categories
        LinkCategorizer.run(model).to_a
      end

      def new_categories?
        categories.map(&:id).any? do |new_category_id|
          !model.category_ids.include?(new_category_id)
        end
      end

      memoize :categories
    end
  end
end
