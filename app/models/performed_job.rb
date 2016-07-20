class PerformedJob < ApplicationRecord
  validates :type, presence: true, uniqueness: { case_sensitive: false, scope: :key }
  validates :key, presence: true, uniqueness: { case_sensitive: false, scope: :type }
  validates :status, :performs, presence: true

  self.inheritance_column = nil
  enum status: { pending: 0, enqueued: 1, running: 2, error: 3, success: 5 }
end
