class ChangeLinkContentToBinary < ActiveRecord::Migration
  def change
    remove_column :links, :content
    add_column :links, :content, :binary
  end
end
