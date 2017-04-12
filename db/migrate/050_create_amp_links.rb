class CreateAmpLinks < ActiveRecord::Migration
  def change
    create_table :amp_links do |t|
      t.integer :link_id, null: false
      t.integer :status, null: false, default: 0
      t.citext :url
      t.timestamps null: false
    end
    add_index :amp_links, :link_id, unique: true
    add_index :amp_links, :status
  end
end
