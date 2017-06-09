class AddFixedOnStoryLinks < ActiveRecord::Migration[5.0]
  def change
    remove_column :links, :content, :binary
  end
end
