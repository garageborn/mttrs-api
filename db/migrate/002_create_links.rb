class CreateLinks < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    create_table :links do |t|
      t.citext :url, null: false
      t.integer :status, default: 0, null: false, index: true
      t.citext :title
      t.text :description
      t.text :content
      t.string :image_public_id
      t.jsonb :social, default: '{}'
      t.timestamps null: false
    end

    add_index :links, :url, unique: true
  end
end
