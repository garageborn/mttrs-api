class RemoveOrderFromCategoryMatchers < ActiveRecord::Migration[5.0]
  def change
    remove_column :category_matchers, :order, :integer, null: false, default: 0
  end
end
