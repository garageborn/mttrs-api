class AddPublishedAtIndexOnStories < ActiveRecord::Migration[5.0]
  def change
    add_index :stories, :published_at
  end
end
