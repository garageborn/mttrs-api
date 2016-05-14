class CreateFeedsStories < ActiveRecord::Migration
  def change
    create_table :feeds_stories, id: false do |t|
      t.integer :feed_id, null: false
      t.integer :story_id, null: false
      t.timestamps null: false
    end

    add_index :feeds_stories, [:feed_id, :story_id], unique: true
    add_index :feeds_stories, [:story_id, :feed_id], unique: true
  end
end
