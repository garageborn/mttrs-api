class AddSourceUrlToStories < ActiveRecord::Migration
  class Story < ActiveRecord::Base; end

  def change
    add_column :stories, :source_url, :citext
    Story.all.each { |story| story.update_attributes(source_url: story.url) }
    change_column :stories, :source_url, :citext, null: false
    add_index :stories, :source_url, unique: true

    change_column :stories, :url, :citext, null: true
    remove_index :stories, :url
    add_index :stories, :url
  end
end
