class AddParentIdToSocialCounters < ActiveRecord::Migration
  def change
    add_column :social_counters, :parent_id, :integer, null: true
    add_index :social_counters, :parent_id, unique: true
  end
end
