class AddPaperclipFingerprints < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :image_fingerprint, :string
    add_column :publishers, :icon_fingerprint, :string
  end
end
