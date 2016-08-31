class CreateLinksNamespaces < ActiveRecord::Migration
  def change
    create_table :links_namespaces, id: false do |t|
      t.integer :link_id, null: false
      t.integer :namespace_id, null: false
      t.timestamps null: false
    end

    add_index :links_namespaces, [:link_id, :namespace_id], unique: true
    add_index :links_namespaces, [:namespace_id, :link_id], unique: true
  end
end
