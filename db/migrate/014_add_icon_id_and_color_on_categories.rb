class AddIconIdAndColorOnCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :icon_id, :string
    add_column :categories, :color, :string
  end
end
