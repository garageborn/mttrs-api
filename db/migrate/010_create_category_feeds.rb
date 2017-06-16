class CreateCategoryFeeds < ActiveRecord::Migration
  def change
    create_table :category_feeds do |t|
      t.integer :category_id, null: false
      t.integer :feed_id, null: false
      t.timestamps null: false
    end
    add_index :category_feeds, %i[category_id feed_id], unique: true
    add_index :category_feeds, %i[feed_id category_id], unique: true
  end
end
