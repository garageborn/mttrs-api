class AddLanguageToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :language, :string, default: 'en', null: false
  end
end
