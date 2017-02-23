class CreateTitleReplacements < ActiveRecord::Migration
  def change
    create_table :title_replacements do |t|
      t.integer :publisher_id, null: false
      t.text :matcher, null: false
      t.timestamps null: false
    end
    add_index :title_replacements, :publisher_id
  end
end
