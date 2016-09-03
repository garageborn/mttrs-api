class AddNamespaceIdsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :namespace_ids, :jsonb, null: false, default: []
    add_index :categories, :namespace_ids, using: :gin
  end
end
