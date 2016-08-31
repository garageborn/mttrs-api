class LinkAssignerJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options max_performs: {
    count: 2,
    key: proc { |link_id| link_id }
  }
  attr_reader :link_id

  def perform(link_id)
    @link_id = link_id
    return if link_id.blank?
    categories_assigned = assign_categories
    namespaces_assigned = assign_namespaces
    categories_assigned && namespaces_assigned
  end

  private

  def assign_categories
    Link::AddCategories.run(id: link_id) do |op|
      return op.model.present? && op.model.categories.present?
    end
    false
  end

  def assign_namespaces
    Link::AddNamespaces.run(id: link_id) do |op|
      return op.model.present? && op.model.namespaces.present?
    end
    false
  end
end
