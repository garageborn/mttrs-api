class Link
  class AddCategories < Operation
    extend Memoist

    def process(_params)
      return invalid! if model.blank?

      categories.each do |category|
        next if model.categories.include?(category)
        model.categories << category
      end
    end

    private

    def model!(params)
      ::Link.find_by_id(params[:id])
    end

    def categories
      LinkCategorizer.run(model).to_a
    end

    memoize :categories
  end
end
