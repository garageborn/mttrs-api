class PublisherSuggestion < ApplicationRecord
  include Concerns::Filterable

  scope :order_by_count, -> { order('publisher_suggestions.count DESC') }
end
