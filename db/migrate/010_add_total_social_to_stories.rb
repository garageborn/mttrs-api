class AddTotalSocialToStories < ActiveRecord::Migration
  def change
    add_column :stories, :total_social, :integer, null: false, default: 0
    add_index :stories, :total_social
  end
end
