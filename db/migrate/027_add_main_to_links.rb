class AddMainToLinks < ActiveRecord::Migration
  class Story < ApplicationRecord
    has_many :links
  end

  class Link < ApplicationRecord
    belongs_to :story
    scope :popular, -> { order(total_social: :desc) }
  end

  def change
    add_column :links, :main, :boolean, default: false, null: false
    set_main_links
  end

  private

  def set_main_links
    Story.find_each do |story|
      main_link = story.links.popular.first
      main_link.update_column(:main, true)
    end
  end
end
