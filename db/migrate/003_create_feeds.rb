class CreateFeeds < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    create_table :feeds do |t|
      t.integer :publisher_id, null: false
      t.integer :category_id, null: false
      t.citext :url, null: false
      t.timestamps null: false
    end
    add_index :feeds, [:publisher_id, :category_id]
    add_index :feeds, [:category_id, :publisher_id]
    add_index :feeds, :url, unique: true
  end
end
