class Story
  module Callbacks
    class Base
      attr_reader :contract

      def initialize(contract)
        @contract = contract
      end
    end

    class AfterUpdate < Base
      def call(_options)
        process_added_links
        process_removed_links
        process_fixed_link
        process_category_change
      end

      private

      def process_added_links
        return if contract.added_links.blank?
        ::Link.where(id: contract.added_links).each do |link|
          Story::AddLink.run(id: contract.model.id, link_id: link.id)
        end
      end

      def process_removed_links
        return if contract.removed_links.blank?
        ::Link.where(id: contract.removed_links).each do |link|
          Story::RemoveLink.run(id: contract.model.id, link_id: link.id)
        end
      end

      def process_fixed_link
        contract.story_links.each do |story_link|
          fixed = story_link.link_id.to_i == contract.fixed_link_id.to_i
          story_link.update_attributes(fixed: fixed)
        end
      end

      def process_category_change
        _previous_category_id, current_category_id = contract.model.previous_changes[:category_id]
        return if current_category_id.blank?
        contract.links.each do |link|
          link.update_attributes(category: contract.model.category)
        end
      end
    end
  end
end
