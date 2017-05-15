class AddFixedOnStoryLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :story_links, :fixed, :boolean, null: false, default: false
  end
end
