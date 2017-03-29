class Link
  class SetTags < Operation
    def process(params)
      Apartment::Tenant.each do
        Link::SetTags::Tenant.run(id: params[:id])
      end
    end

    class Tenant < Operation
      extend Memoist

      action :find

      def process(_params)
        return if model.blank? || new_tags.blank?
        model.update_attributes(tags: new_tags)
      end

      private

      def new_tags
        model.publisher.tag_matchers.to_a.select do |tag_matcher|
          tag_matcher.match?(model)
        end.map(&:tag)
      end

      memoize :new_tags
    end
  end
end
