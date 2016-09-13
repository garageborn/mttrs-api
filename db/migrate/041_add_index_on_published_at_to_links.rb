class AddIndexOnPublishedAtToLinks < ActiveRecord::Migration
  def change
    add_index :links, :published_at
  end
end
