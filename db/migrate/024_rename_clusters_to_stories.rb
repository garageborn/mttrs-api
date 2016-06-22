class RenameClustersToStories < ActiveRecord::Migration
  def change
    rename_table :clusters, :stories
    rename_column :links, :cluster_id, :story_id
  end
end
