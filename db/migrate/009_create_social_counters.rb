class CreateSocialCounters < ActiveRecord::Migration
  def change
    create_table :social_counters do |t|
      t.integer :story_id, null: false
      t.integer :facebook, null: false, default: 0
      t.integer :linkedin, null: false, default: 0
      t.integer :total, null: false, default: 0
      t.timestamps null: false
    end
    add_index :social_counters, [:story_id, :total]
  end
end
