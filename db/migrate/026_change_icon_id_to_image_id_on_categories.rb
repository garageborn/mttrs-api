class ChangeIconIdToImageIdOnCategories < ActiveRecord::Migration[5.0]
  def change
    rename_column :categories, :icon_id, :image_id
  end
end
