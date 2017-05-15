class StoryLink < ApplicationRecord
  belongs_to :story
  belongs_to :link
  has_one :publisher, through: :link

  scope :popular, -> { joins(:link).order('links.total_social DESC') }
  scope :unrestrict_content, -> { joins(:publisher).where(publishers: { restrict_content: false }) }

  def self.fixed
    where(fixed: true).first
  end
end
