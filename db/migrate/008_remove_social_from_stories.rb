class RemoveSocialFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :social, :jsonb, default: '{}'
  end
end
