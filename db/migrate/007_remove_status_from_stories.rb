class RemoveStatusFromStories < ActiveRecord::Migration
  class Story < ActiveRecord::Base; end

  def change
    remove_column :stories, :status

    Story.where(url: nil).destroy_all
    change_column :stories, :url, :citext, null: false
    remove_index :stories, :url
    add_index :stories, :url, unique: true

    add_column :stories, :image_source_url, :citext

    Story.where(title: nil).destroy_all
    change_column :stories, :title, :citext, null: false

    Story.where(description: nil).destroy_all
    change_column :stories, :description, :text, null: false
  end
end
