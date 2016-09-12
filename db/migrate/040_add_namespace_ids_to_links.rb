class AddNamespaceIdsToLinks < ActiveRecord::Migration
  def change
    add_column :links, :namespace_ids, :integer, array: true, null: false, default: []
    add_index :links, :namespace_ids, using: :gin
  end
end
