class ChangeStoriesDescription < ActiveRecord::Migration
  def change
    change_column :stories, :description, :text, null: true
  end
end
