class AmpLink < ApplicationRecord
  enum status: %i[pending fetching error success]
  belongs_to :link

  scope :recent, -> { order(created_at: :desc) }
end
