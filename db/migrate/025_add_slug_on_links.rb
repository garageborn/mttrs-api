class AddSlugOnLinks < ActiveRecord::Migration[5.0]
  class Link < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: %i(slugged finders)
  end

  def change
    add_column :links, :slug, :citext
    add_index :links, :slug, unique: true
    generate_slugs
    change_column :links, :slug, :citext, null: false
  end

  private

  def generate_slugs
    Link.find_each(&:save)
  end
end
