class AddHtmlToStories < ActiveRecord::Migration
  def change
    add_column :stories, :html, :text
  end
end
