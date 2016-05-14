class CreateStories < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    create_table :stories do |t|
      t.integer :publisher_id, null: false, index: true
      t.citext :url, null: false
      t.integer :status, default: 0, null: false, index: true
      t.citext :title
      t.text :description
      t.text :content
      t.string :image_public_id
      t.jsonb :social, default: '{}'
      t.timestamps null: false
    end

    add_index :stories, :url, unique: true
  end
end
