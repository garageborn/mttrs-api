class ColorAndImageIdNotNullOnCategories < ActiveRecord::Migration[5.0]
  def change
    change_column :categories, :image_id, :string, null: false
    change_column :categories, :color, :string, null: false
  end
end
