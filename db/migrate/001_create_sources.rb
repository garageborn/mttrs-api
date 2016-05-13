class CreateSources < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    create_table :sources do |t|
      t.citext :name, null: false
      t.citext :rss, null: false
      t.timestamps null: false
    end
    add_index :sources, :name, unique: true
    add_index :sources, :rss, unique: true
  end
end
