class RenameStoriesToLinks < ActiveRecord::Migration
  def change
    rename_table :stories, :links
    rename_table :categories_stories, :categories_links
    rename_table :feeds_stories, :feeds_links

    rename_column :categories_links, :story_id, :link_id
    rename_column :feeds_links, :story_id, :link_id
    rename_column :social_counters, :story_id, :link_id
  end
end
