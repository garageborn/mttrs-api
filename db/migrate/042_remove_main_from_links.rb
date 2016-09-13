class RemoveMainFromLinks < ActiveRecord::Migration
  def change
    remove_column :links, :main, :boolean, null: false, default: false
    remove_column :links, :total_social, :integer, null: false, default: 0
  end
end
