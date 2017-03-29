class AddPublisherIdOnTagMatchers < ActiveRecord::Migration[5.0]
  def change
    add_column :tag_matchers, :publisher_id, :integer, null: false
    add_index :tag_matchers, :publisher_id
  end
end
