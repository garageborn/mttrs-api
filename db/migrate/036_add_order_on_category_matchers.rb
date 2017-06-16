class AddOrderOnCategoryMatchers < ActiveRecord::Migration[5.0]
  def change
    add_column :category_matchers, :order, :integer, null: false, default: 0
    add_index :category_matchers, %i[publisher_id order]
  end
end
