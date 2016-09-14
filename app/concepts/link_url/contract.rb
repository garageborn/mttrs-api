class LinkUrl
  class Contract < Reform::Form
    property :link_id
    property :url

    validates :link_id, presence: true
    validates :source_url, :url, presence: true, unique: { case_sensitive: false }
    # validate :validate_unique_link

    # def validate_unique_link
    #   return if publisher.blank?
    #   other_link = publisher.links.where(title: title).where.not(id: id).first
    #   return if other_link.blank?
    #   errors.add(:url, :invalid) if other_link.uri.path == uri.path
    # end
  end
end
