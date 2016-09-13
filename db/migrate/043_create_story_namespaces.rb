class CreateStoryNamespaces < ActiveRecord::Migration
  def change
    create_table :story_namespaces do |t|
      t.integer :story_id, null: false
      t.integer :namespace_id, null: false
      t.integer :main_link_id, null: false
      t.integer :total_social, null: false, default: 0
    end

    add_index :story_namespaces, [:story_id, :namespace_id], unique: true
    add_index :story_namespaces, [:namespace_id, :story_id], unique: true
  end
end
