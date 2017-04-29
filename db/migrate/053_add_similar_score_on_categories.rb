class AddSimilarScoreOnCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :similar_min_score, :float, null: false, default: 1.5
  end
end
