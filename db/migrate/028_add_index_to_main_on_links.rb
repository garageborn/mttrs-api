class AddIndexToMainOnLinks < ActiveRecord::Migration
  def change
    remove_index :links, :story_id
    add_index :links, [:story_id, :main]
    add_index :links, [:main, :story_id]
  end
end
