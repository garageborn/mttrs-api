class SocialCounter < ActiveRecord::Base
  PROVIDERS = %i(facebook linkedin).freeze
  belongs_to :story
  has_one :parent, class_name: 'SocialCounter', foreign_key: :parent_id

  validates :story, :facebook, :linkedin, :total, presence: true
  validates :facebook, :linkedin, :total,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :parent_id, uniqueness: true, allow_blank: true

  before_save :update_total
  after_commit :update_total_social_on_story, on: [:create, :update]

  scope :recent, -> { order(created_at: :desc) }

  def increased?
    return true if parent.blank?
    PROVIDERS.any? do |provider|
      self.read_attribute(provider) > parent.read_attribute(provider)
    end
  end

  private

  def update_total
    self.total = PROVIDERS.map { |provider| read_attribute(provider) }.sum
  end

  def update_total_social_on_story
    story.update_column(:total_social, total)
  end
end
