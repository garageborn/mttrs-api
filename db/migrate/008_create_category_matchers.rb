class CreateCategoryMatchers < ActiveRecord::Migration
  def change
    create_table :category_matchers do |t|
      t.integer :publisher_id, null: false
      t.integer :category_id, null: false
      t.integer :order, null: false, default: 0
      t.text :url_matcher
      t.timestamps null: false
    end
    add_index :category_matchers, [:publisher_id, :category_id], unique: true
    add_index :category_matchers, [:category_id, :publisher_id], unique: true
  end
end
