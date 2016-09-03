class AddNamespaceIdsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :namespace_ids, :integer, array: true, null: false, default: []
    add_index :categories, :namespace_ids, using: :gin
  end
end
