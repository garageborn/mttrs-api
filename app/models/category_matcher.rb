class CategoryMatcher < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :category

  validates :publisher, :category, presence: true
  validates :url_matcher,
            uniqueness: { case_sensitive: false, scope: :publisher_id },
            allow_blank: true
end
