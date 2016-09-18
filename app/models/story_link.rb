class StoryLink < ApplicationRecord
  belongs_to :story
  belongs_to :link

  scope :popular, -> { joins(:link).order('links.total_social DESC') }
end
