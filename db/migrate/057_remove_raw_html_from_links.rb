class RemoveRawHtmlFromLinks < ActiveRecord::Migration[5.0]
  def change
    remove_column :links, :raw_html, :binary
  end
end
