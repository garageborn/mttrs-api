class DropFeeds < ActiveRecord::Migration[5.0]
  def up
    drop_table :feeds
    drop_table :feed_links
    drop_table :category_feeds
  end
end
