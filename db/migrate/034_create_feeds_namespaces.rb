class CreateFeedsNamespaces < ActiveRecord::Migration
  def change
    create_table :feeds_namespaces, id: false do |t|
      t.integer :feed_id, null: false
      t.integer :namespace_id, null: false
      t.timestamps null: false
    end

    add_index :feeds_namespaces, [:feed_id, :namespace_id], unique: true
    add_index :feeds_namespaces, [:namespace_id, :feed_id], unique: true
  end
end
