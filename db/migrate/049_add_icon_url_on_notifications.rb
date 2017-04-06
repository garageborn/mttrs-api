class AddIconUrlOnNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :icon_url, :citext
    change_column :notifications, :title, :citext, null: true
  end
end
