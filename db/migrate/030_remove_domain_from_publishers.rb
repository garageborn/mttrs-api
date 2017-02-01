class RemoveDomainFromPublishers < ActiveRecord::Migration[5.0]
  class Publisher < ApplicationRecord; end
  class PublisherDomain < ApplicationRecord; end

  def change
    migrate_domain_to_publisher_domain!
    remove_column :publishers, :domain, :citext
  end

  private

  def migrate_domain_to_publisher_domain!
    Publisher.find_each do |publisher|
      PublisherDomain.create(publisher_id: publisher.id, domain: publisher.domain)
    end
  end
end
