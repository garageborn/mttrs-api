class Publisher < ApplicationRecord
  include Concerns::Filterable
  extend FriendlyId

  has_many :category_matchers, inverse_of: :publisher, dependent: :destroy
  has_many :feeds, inverse_of: :publisher, dependent: :destroy
  has_many :links, inverse_of: :publisher, dependent: :destroy

  friendly_id :name, use: %i(slugged finders)
end
