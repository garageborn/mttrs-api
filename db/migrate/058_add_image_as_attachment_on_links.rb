class AddImageAsAttachmentOnLinks < ActiveRecord::Migration[5.0]
  def change
    add_attachment :links, :image
  end
end
