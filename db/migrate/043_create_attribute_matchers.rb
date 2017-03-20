class CreateAttributeMatchers < ActiveRecord::Migration[5.0]
  def change
    create_table :attribute_matchers do |t|
      t.integer :publisher_id, null: false
      t.string :name, null: false
      t.text :matcher, null: false
      t.timestamps null: false
    end
    add_index :attribute_matchers, [:publisher_id, :name]
  end
end
