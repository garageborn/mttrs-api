class AddHtmlAsAttachmentOnLinks < ActiveRecord::Migration[5.0]
  def change
    rename_column :links, :html, :raw_html
    add_attachment :links, :html
  end
end
