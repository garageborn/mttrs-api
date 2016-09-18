class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :total_social, null: false, default: 0
      t.timestamps null: false
    end
    add_index :stories, :total_social
  end
end
