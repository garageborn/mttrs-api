class CreatePublisherDomains < ActiveRecord::Migration
  def change
    create_table :publisher_domains do |t|
      t.integer :publisher_id, null: false
      t.citext :domain, null: false
      t.timestamps null: false
    end
    add_index :publisher_domains, :publisher_id
    add_index :publisher_domains, :domain, unique: true
  end
end
