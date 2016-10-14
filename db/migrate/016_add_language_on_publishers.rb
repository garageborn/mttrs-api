class AddLanguageOnPublishers < ActiveRecord::Migration[5.0]
  def change
    add_column :publishers, :language, :string, null: false, default: 'en'
  end
end
