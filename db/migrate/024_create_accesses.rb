class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :accessable_type, null: false
      t.integer :accessable_id, null: false
      t.date :date, null: false
      t.integer :hour, null: false
      t.integer :hits, null: false, default: 1
    end
    add_index :accesses, [:accessable_type, :accessable_id, :date, :hour],
              name: 'index_accesses_on_accessable_and_date_and_hour', unique: true
    add_index :accesses, [:date, :hour]
    add_index :accesses, :hits
  end
end
