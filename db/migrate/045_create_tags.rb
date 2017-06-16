class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :category_id, null: false
      t.citext :name, null: false
      t.integer :order, null: false, default: 0
      t.citext :slug, null: false
      t.timestamps null: false
    end
    add_index :tags, %i[category_id order]
    add_index :tags, :slug, unique: true
  end
end
