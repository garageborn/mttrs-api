class CreateTagMatchers < ActiveRecord::Migration
  def change
    create_table :tag_matchers do |t|
      t.integer :tag_id, null: false
      t.text :url_matcher
      t.text :html_matcher_selector
      t.text :html_matcher
      t.timestamps null: false
    end
    add_index :tag_matchers, :tag_id
  end
end
