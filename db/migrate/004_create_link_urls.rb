class CreateLinkUrls < ActiveRecord::Migration
  def change
    create_table :link_urls do |t|
      t.integer :link_id, null: false
      t.citext :url, null: false
      t.timestamps null: false
    end

    add_index :link_urls, :url, unique: true
    add_index :link_urls, [:link_id, :url], unique: true
  end
end
