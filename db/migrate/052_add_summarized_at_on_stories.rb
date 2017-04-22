class AddSummarizedAtOnStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :summarized_at, :datetime
    add_index :stories, :summarized_at
  end
end
