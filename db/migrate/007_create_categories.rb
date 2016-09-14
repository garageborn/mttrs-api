class CreateCategories < ActiveRecord::Migration
  def change
    enable_extension :citext

    create_table :categories do |t|
      t.citext :name, null: false
      t.citext :slug, null: false
      t.timestamps null: false
    end
    add_index :categories, :name, unique: true
    add_index :categories, :slug, unique: true
  end
end
