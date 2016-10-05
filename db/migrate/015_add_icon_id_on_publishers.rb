class AddIconIdOnPublishers < ActiveRecord::Migration[5.0]
  def change
    add_column :publishers, :icon_id, :string
  end
end
