class CreatePublisherSuggestions < ActiveRecord::Migration
  def change
    create_table :publisher_suggestions do |t|
      t.citext :name, null: false
      t.integer :count, null: false, default: 0
      t.timestamps null: false
    end
    add_index :publisher_suggestions, :name, unique: true
    add_index :publisher_suggestions, :count
  end
end
