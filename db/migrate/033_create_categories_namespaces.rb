class CreateCategoriesNamespaces < ActiveRecord::Migration
  def change
    create_table :categories_namespaces, id: false do |t|
      t.integer :category_id, null: false
      t.integer :namespace_id, null: false
      t.timestamps null: false
    end

    add_index :categories_namespaces, [:category_id, :namespace_id], unique: true
    add_index :categories_namespaces, [:namespace_id, :category_id], unique: true
  end
end
