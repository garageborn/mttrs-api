class AddNamespaceIdsToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :namespace_ids, :integer, array: true, null: false, default: []
    add_index :feeds, :namespace_ids, using: :gin
  end
end
