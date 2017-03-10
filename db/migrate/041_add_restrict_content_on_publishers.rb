class AddRestrictContentOnPublishers < ActiveRecord::Migration[5.0]
  def change
    add_column :publishers, :restrict_content, :boolean, null: false, default: false
    add_index :publishers, :restrict_content
  end
end
