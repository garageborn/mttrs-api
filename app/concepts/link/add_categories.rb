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
        return if new_category.blank? || !new_categories?

        return if model.categories.include?(new_category)
        model.categories << new_category

        StoryBuilderJob.perform_async(model.id)
      end

      private

      def new_category
        LinkCategorizer.run(model)
      end

      def new_categories?
        !model.category_ids.include?(new_category.id)
      end

      memoize :new_category
    end
  end
end
