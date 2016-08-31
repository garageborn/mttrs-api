class Link
  class AddNamespaces < Operation
    extend Memoist

    def process(_params)
      return invalid! if model.blank?

      namespaces.each do |namespace|
        next if model.namespaces.include?(namespace)
        model.namespaces << namespace
      end
    end

    private

    def model!(params)
      ::Link.find_by_id(params[:id])
    end

    def namespaces
      (feeds_namespaces + categories_namespaces).flatten.compact.uniq
    end

    def feeds_namespaces
      model.feeds.map(&:namespaces).flatten.compact.uniq
    end

    def categories_namespaces
      model.categories.map(&:namespaces).flatten.compact.uniq
    end

    memoize :namespaces, :feeds_namespaces, :categories_namespaces
  end
end
