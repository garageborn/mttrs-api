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
      end

      private

      def process_added_links
        return if contract.added_links.blank?
        ::Link.where(id: contract.added_links).each do |link|
          Story::AddLink.run(id: contract.model.id, link_id: link.id)
        end
      end

      def process_removed_links
        p '-------------------contract.removed_links', contract.removed_links
        return if contract.removed_links.blank?
        ::Link.where(id: contract.removed_links).each do |link|
          p '----------process_removed_links', link.id
          Story::RemoveLink.run(id: contract.model.id, link_id: link.id)
        end
      end
    end
  end
end
