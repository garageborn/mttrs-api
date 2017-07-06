class AddIconAsAttachmentOnPublishers < ActiveRecord::Migration[5.0]
  class Publisher < ApplicationRecord
    has_attached_file :icon, styles: { xsmall: '50x50', small: '30x30', medium: '22x22' }
    validates_attachment_content_type :icon, content_type: /\Aimage/
  end

  def up
    add_attachment :publishers, :icon
    migrate_icon_id!
    change_column :publishers, :icon_file_name, :string, null: false
    change_column :publishers, :icon_content_type, :string, null: false
    change_column :publishers, :icon_file_size, :integer, null: false
    change_column :publishers, :icon_updated_at, :datetime, null: false
    change_column :publishers, :icon_id, :string, null: true
  end

  def down
    remove_attachment :publishers, :icon
    change_column :publishers, :icon_id, :string, null: false
  end

  private

  def migrate_icon_id!
    ::Publisher.find_each do |publisher|
      next if publisher.icon_id.blank? || publisher.icon.present?
      icon_url = Cloudinary::Utils.cloudinary_url(publisher.icon_id)
      Rails.logger.info "#{ publisher.slug }    #{ icon_url }"
      publisher.update_attributes(icon: URI.parse(icon_url))
    end
  end
end
