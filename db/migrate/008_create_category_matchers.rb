class CreateCategoryMatchers < ActiveRecord::Migration
  def change
    create_table :category_matchers do |t|
      t.integer :publisher_id, null: false
      t.integer :category_id, null: false
      t.integer :order, null: false, default: 0
      t.text :url_matcher
      t.timestamps null: false
    end
    add_index :category_matchers, %i[publisher_id category_id]
    add_index :category_matchers, %i[category_id publisher_id]
  end
end
