class AddIconAsAttachmentOnPublishers < ActiveRecord::Migration[5.0]
  class Publisher < ApplicationRecord
    has_attached_file :icon, styles: { xsmall: '22x22', small: '30x30', medium: '50x50' }
    validates_attachment_content_type :icon, content_type: /\Aimage/
  end

  def up
    add_attachment :publishers, :icon, null: false
    change_column :publishers, :icon_id, :string, null: true
  end

  def down
    remove_attachment :publishers, :icon
    change_column :publishers, :icon_id, :string, null: false
  end
end
