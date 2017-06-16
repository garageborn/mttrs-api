class CreateStoryLinks < ActiveRecord::Migration
  def change
    create_table :story_links do |t|
      t.integer :story_id, null: false
      t.integer :link_id, null: false
      t.integer :main, null: false, default: false
      t.timestamps null: false
    end
    add_index :story_links, %i[story_id link_id], unique: true
    add_index :story_links, %i[main story_id]
    add_index :story_links, %i[link_id story_id], unique: true
  end
end
