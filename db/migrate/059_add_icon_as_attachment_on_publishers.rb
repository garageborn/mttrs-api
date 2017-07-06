class AddIconAsAttachmentOnPublishers < ActiveRecord::Migration[5.0]
  def change
    add_attachment :links, :icon
  end
end
