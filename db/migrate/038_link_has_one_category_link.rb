class LinkHasOneCategoryLink < ActiveRecord::Migration[5.0]
  class CategoryLink < ApplicationRecord; end

  def change
    destroy_secondary_category_links
    add_index :category_links, :link_id, unique: true
  end

  private

  def destroy_secondary_category_links
    Apartment::Tenant.each do
      CategoryLink.pluck(:link_id).uniq.each do |link_id|
        CategoryLink.where(link_id: link_id).offset(1).destroy_all
      end
    end
  end
end
