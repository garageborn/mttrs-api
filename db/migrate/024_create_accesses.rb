class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :accessable_type, null: false
      t.integer :accessable_id, null: false
      t.datetime :date, null: false
      t.integer :hits, null: false, default: 1
    end
    add_index :accesses,
              [:accessable_type, :accessable_id, :date],
              name: 'index_access_on_assetable_and_created_at',
              unique: true
    add_index :accesses, :date
    add_index :accesses, :hits
  end
end
