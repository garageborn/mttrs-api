class CreatePublishers < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    create_table :publishers do |t|
      t.citext :name, null: false
      t.timestamps null: false
    end
    add_index :publishers, :name, unique: true
  end
end
