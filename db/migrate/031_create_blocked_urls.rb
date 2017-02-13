class CreateBlockedUrls < ActiveRecord::Migration
  def change
    create_table :blocked_urls do |t|
      t.integer :publisher_id, null: false
      t.text :matcher, null: false
      t.timestamps null: false
    end
    add_index :blocked_urls, :publisher_id
  end
end
