class AddHtmlToStories < ActiveRecord::Migration
  class Story < ActiveRecord::Base; end

  def change
    add_column :stories, :html, :text
  end
end
