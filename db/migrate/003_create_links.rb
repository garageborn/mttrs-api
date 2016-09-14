class CreateLinks < ActiveRecord::Migration
  def change
    enable_extension :citext

    create_table :links do |t|
      t.integer :publisher_id, null: false
      t.citext :title, null: false
      t.text :description
      t.text :content
      t.citext :image_source_url
      t.integer :total_social, default: 0, null: false
      t.datetime :published_at, null: false
      t.string :language
      t.binary :html
      t.timestamps null: false
    end

    add_index :links, :published_at
    add_index :links, :publisher_id
    add_index :links, :total_social
  end
end
