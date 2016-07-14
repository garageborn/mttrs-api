class AddDomainToPublishers < ActiveRecord::Migration
  class Publisher < ApplicationRecord
    has_many :feeds
  end

  def change
    add_column :publishers, :domain, :citext
    set_domains!
    change_column :publishers, :domain, :citext, null: false
  end

  private

  def set_domains!
    Publisher.all.each do |publisher|
      domains = publisher.feeds.map do |feed|
        host = Addressable::URI.parse(feed.url).host
        PublicSuffix.domain(host)
      end.compact.uniq
      publisher.update_column(:domain, domains.first)
    end
  end
end
