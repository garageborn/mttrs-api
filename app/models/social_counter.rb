class SocialCounter < ApplicationRecord
  PROVIDERS = %i(facebook linkedin twitter pinterest google_plus).freeze
  belongs_to :link
  has_one :parent, class_name: 'SocialCounter', foreign_key: :parent_id

  before_save :update_total

  scope :recent, -> { order(created_at: :desc) }

  def increased?
    return true if parent.blank?
    PROVIDERS.any? do |provider|
      self[provider] > parent[provider]
    end
  end

  private

  def update_total
    self.total = PROVIDERS.map { |provider| self[provider] }.sum
  end
end
