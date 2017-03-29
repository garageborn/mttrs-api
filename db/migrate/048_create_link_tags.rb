class CreateLinkTags < ActiveRecord::Migration
  def change
    create_table :link_tags do |t|
      t.integer :tag_id, null: false
      t.integer :link_id, null: false
      t.timestamps null: false
    end
    add_index :link_tags, [:tag_id, :link_id], unique: true
    add_index :link_tags, [:link_id, :tag_id], unique: true
  end
end
