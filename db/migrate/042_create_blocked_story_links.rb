class CreateBlockedStoryLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :blocked_story_links do |t|
      t.integer :story_id, null: false
      t.integer :link_id, null: false
      t.timestamps null: false
    end
    add_index :blocked_story_links, %i[story_id link_id], unique: true
    add_index :blocked_story_links, %i[link_id story_id], unique: true
  end
end
