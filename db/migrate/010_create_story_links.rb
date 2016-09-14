class CreateStoryLinks < ActiveRecord::Migration
  def change
    create_table :story_links do |t|
      t.integer :story_id, null: false
      t.integer :link_id, null: false
      t.timestamps null: false
    end
    add_index :story_links, [:story_id, :link_id]
    add_index :story_links, [:link_id, :story_id]
  end
end
