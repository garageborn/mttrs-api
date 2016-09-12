class Link
  class AddNamespaces < Operation
    extend Memoist

    def process(_params)
      return invalid! if model.blank?
      namespace_ids.each do |namespace_id|
        model.namespaces << namespace_id
      end
      model.save
    end

    private

    def model!(params)
      ::Link.find_by_id(params[:id])
    end

    def namespace_ids
      (feeds_namespace_ids + categories_namespace_ids).flatten.compact.uniq
    end

    def feeds_namespace_ids
      model.feeds.map(&:namespace_ids).flatten.compact.uniq
    end

    def categories_namespace_ids
      model.categories.map(&:namespace_ids).flatten.compact.uniq
    end

    memoize :namespace_ids, :feeds_namespace_ids, :categories_namespace_ids
  end
end
