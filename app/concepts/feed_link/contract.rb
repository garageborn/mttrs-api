class FeedLink
  class Contract < Reform::Form
    property :feed_id
    property :link_id

    validates :feed_id, :link_id, presence: true
  end
end
