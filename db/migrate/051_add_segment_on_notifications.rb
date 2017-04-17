class AddSegmentOnNotifications < ActiveRecord::Migration[5.0]
  class Notification < ActiveRecord::Base; end

  def change
    Apartment::Tenant.each { Notification.destroy_all }
    add_column :notifications, :segment, :citext, null: false
  end
end
