class AddNewTotalSocialToStories < ActiveRecord::Migration
  def change
    add_column :stories, :total_social, :integer, default: 0, null: false
    add_index :stories, :total_social
  end
end
