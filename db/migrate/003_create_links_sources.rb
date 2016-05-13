class CreateLinksSources < ActiveRecord::Migration
  def change
    create_table :links_sources, id: false do |t|
      t.integer :link_id, null: false
      t.integer :source_id, null: false
      t.timestamps null: false
    end

    add_index :links_sources, [:source_id, :link_id], unique: true
    add_index :links_sources, [ :link_id, :source_id], unique: true
  end
end
