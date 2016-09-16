class CreateSocialCounters < ActiveRecord::Migration
  def change
    enable_extension :citext

    create_table :social_counters do |t|
      t.integer :link_id, null: false
      t.integer :parent_id
      t.integer :total, default: 0, null: false
      t.integer :facebook, default: 0, null: false
      t.integer :linkedin, default: 0, null: false
      t.integer :twitter, default: 0, null: false
      t.integer :pinterest, default: 0, null: false
      t.integer :google_plus, default: 0, null: false
      t.timestamps null: false
    end

    add_index :social_counters, [:link_id, :total]
    add_index :social_counters, :parent_id, unique: true
  end
end
