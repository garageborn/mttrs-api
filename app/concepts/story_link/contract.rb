class StoryLink
  class Contract < Reform::Form
    property :story_id
    property :link_id

    validates :story_id, :link_id, presence: true
  end
end
