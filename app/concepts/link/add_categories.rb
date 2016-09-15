class Link
  class AddCategories < Operation
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
