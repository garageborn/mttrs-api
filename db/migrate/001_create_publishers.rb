class CreatePublishers < ActiveRecord::Migration
  def change
    enable_extension :citext

    create_table :publishers do |t|
      t.citext :name, null: false
      t.citext :slug, null: false
      t.citext :domain, null: false
      t.timestamps null: false
    end
    add_index :publishers, :name, unique: true
    add_index :publishers, :domain, unique: true
    add_index :publishers, :slug, unique: true
  end
end
