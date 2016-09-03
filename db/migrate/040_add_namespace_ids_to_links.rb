class AddNamespaceIdsToLinks < ActiveRecord::Migration
  def change
    add_column :links, :namespace_ids, :jsonb, null: false, default: []
    add_index :links, :namespace_ids, using: :gin
  end
end
