class AddLanguageToStories < ActiveRecord::Migration
  def change
    add_column :stories, :language, :string
  end
end
