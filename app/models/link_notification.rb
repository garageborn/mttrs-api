class LinkNotification < Notification
  extend Memoist
  attr_accessor :link_id

  def link
    Link.find_by(id: link_id)
  end

  private

  def data
    return if link.blank?
    {
      type: :link,
      tenant: Apartment::Tenant.current,
      model: {
        id: link.id,
        slug: link.slug,
        story: { id: link.story.try(:id) }
      }
    }
  end

  memoize :link
end
