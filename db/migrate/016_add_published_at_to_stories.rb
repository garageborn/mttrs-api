class AddPublishedAtToStories < ActiveRecord::Migration
  class Story < ActiveRecord::Base; end

  def change
    add_column :stories, :published_at, :datetime
    Story.all.each { |story| story.update_column(:published_at, story.created_at) }
    change_column :stories, :published_at, :datetime, null: true
  end
end
