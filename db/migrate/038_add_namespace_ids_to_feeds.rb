class AddNamespaceIdsToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :namespace_ids, :jsonb, null: false, default: []
    add_index :feeds, :namespace_ids
  end
end
