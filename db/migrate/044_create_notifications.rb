class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :notificable_type
      t.integer :notificable_id
      t.citext :title, null: false
      t.text :message, null: false
      t.citext :image_url
      t.citext :onesignal_id
      t.text :response
      t.timestamps null: false
    end
    add_index :notifications, %i[notificable_type notificable_id]
    add_index :notifications, %i[notificable_id notificable_type]
  end
end
