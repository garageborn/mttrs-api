class AmpLink < ApplicationRecord
  enum status: %i(pending fetching error success)
  belongs_to :link
end
