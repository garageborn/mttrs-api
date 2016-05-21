class SocialCounter < ActiveRecord::Base
  belongs_to :story

  validates :story, :facebook, :linkedin, :total, presence: true
  validates :facebook, :linkedin, :total,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_save :update_total
  after_commit :update_total_social_on_story, on: [:create, :update]

  private

  def update_total
    self.total = [facebook, linkedin].sum
  end

  def update_total_social_on_story
    story.update_column(:total_social, total)
  end
end
