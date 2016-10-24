class AddHeadlineAndSummaryOnStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :headline, :string
    add_column :stories, :summary, :text
  end
end
