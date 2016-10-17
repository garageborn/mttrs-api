class AddPublishedAtOnStories < ActiveRecord::Migration[5.0]
  class Story < ApplicationRecord
    has_many :links, through: :story_links
    has_many :story_links, inverse_of: :story
    has_one :main_link, through: :main_story_link, source: :link
    has_one :main_story_link, -> { where(main: true) }, class_name: 'StoryLink'
  end

  def change
    add_column :stories, :published_at, :datetime
    set_published_at!
    change_column :stories, :published_at, :datetime, null: false
  end

  private

  def set_published_at!
    Story.find_each do |story|
      main_link = story.main_link || story.links.first
      if main_link
        story.update_attributes(published_at: main_link.published_at)
      else
        story.destroy
      end
    end
  end
end
