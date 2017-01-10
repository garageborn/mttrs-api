class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :accessable_type, null: false
      t.integer :accessable_id, null: false
      t.datetime :created_at, null: false
      t.integer :hits, null: false, default: 1
    end
    add_index :accesses, [:accessable_type, :accessable_id]
    add_index :accesses, :hits
    add_index :accesses, :created_at
  end
end
