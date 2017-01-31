class IconIdNotNullOnPublishers < ActiveRecord::Migration[5.0]
  def change
    change_column :publishers, :icon_id, :string, null: false
  end
end
