class Proxy < ApplicationRecord
  include Concerns::Filterable

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :random, -> { order('RANDOM()') }
  scope :sample, lambda {
    active.random.first || inactive.random.first
  }
end
