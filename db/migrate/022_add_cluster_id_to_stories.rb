class AddClusterIdToStories < ActiveRecord::Migration
  def change
    add_column :stories, :cluster_id, :integer
    add_index :stories, :cluster_id
  end
end
