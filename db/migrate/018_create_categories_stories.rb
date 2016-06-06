class CreateCategoriesStories < ActiveRecord::Migration
  def change
    create_table :categories_stories, id: false do |t|
      t.integer :category_id, null: false
      t.integer :story_id, null: false
      t.timestamps null: false
    end

    add_index :categories_stories, [:category_id, :story_id], unique: true
    add_index :categories_stories, [:story_id, :category_id], unique: true
  end
end
