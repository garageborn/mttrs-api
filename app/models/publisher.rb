class Publisher < ApplicationRecord
  include Concerns::Filterable
  extend FriendlyId

  has_many :category_matchers, inverse_of: :publisher, dependent: :destroy
  has_many :feeds, inverse_of: :publisher, dependent: :destroy
  has_many :links, inverse_of: :publisher, dependent: :destroy

  before_destroy :destroy_tenant_associations!
  friendly_id :name, use: %i(slugged finders)

  private

  def destroy_tenant_associations!
    Apartment::Tenant.each do
      model = contract.model.reload
      model.category_matchers.try(:destroy_all)
    end
  end
end
