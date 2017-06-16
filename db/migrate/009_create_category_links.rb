class CreateCategoryLinks < ActiveRecord::Migration
  def change
    create_table :category_links do |t|
      t.integer :category_id, null: false
      t.integer :link_id, null: false
      t.timestamps null: false
    end
    add_index :category_links, %i[category_id link_id], unique: true
    add_index :category_links, %i[link_id category_id], unique: true
  end
end
