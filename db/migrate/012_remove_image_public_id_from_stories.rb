class RemoveImagePublicIdFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :image_public_id, :string
  end
end
