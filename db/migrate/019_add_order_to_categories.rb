class AddOrderToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :order, :integer, null: false, default: 0
    add_index :categories, :order
  end
end
