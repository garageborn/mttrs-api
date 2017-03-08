class AddCategoryIdOnStories < ActiveRecord::Migration[5.0]
  def up
    add_column :stories, :category_id, :integer
    add_index :stories, :category_id
  end

  def down
    remove_column :stories, :category_id
  end
end
