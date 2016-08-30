class CreateNamespaces < ActiveRecord::Migration
  def change
    create_table :namespaces do |t|
      t.citext :slug, null: false
      t.timestamps null: false
    end
    add_index :namespaces, :slug, unique: true
  end
end
