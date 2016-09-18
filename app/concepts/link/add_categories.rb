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
        categories.each do |category|
          next if model.categories.include?(category)
          model.categories << category
        end
      end

      private

      def categories
        LinkCategorizer.run(model).to_a
      end

      memoize :categories
    end
  end
end
