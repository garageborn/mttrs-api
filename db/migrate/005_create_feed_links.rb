class CreateFeedLinks < ActiveRecord::Migration
  def change
    create_table :feed_links do |t|
      t.integer :feed_id, null: false
      t.integer :link_id, null: false
      t.timestamps null: false
    end

    add_index :feed_links, %i[feed_id link_id], unique: true
    add_index :feed_links, %i[link_id feed_id], unique: true
  end
end
