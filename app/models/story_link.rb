class StoryLink < ApplicationRecord
  belongs_to :story
  belongs_to :link
end
