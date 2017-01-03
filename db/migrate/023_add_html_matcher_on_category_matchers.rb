class AddHtmlMatcherOnCategoryMatchers < ActiveRecord::Migration[5.0]
  def change
    add_column :category_matchers, :html_matcher, :text
    add_column :category_matchers, :html_matcher_selector, :text
  end
end
