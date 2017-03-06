class AddDisplayNameOnPublishers < ActiveRecord::Migration[5.0]
  def change
    add_column :publishers, :display_name, :citext
  end
end
