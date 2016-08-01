class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.inet :ip, null: false
      t.string :port, null: false
      t.boolean :active, null: false, default: true
      t.datetime :requested_at
      t.timestamps null: false
    end

    add_index :proxies, [:ip, :port], unique: true
    add_index :proxies, :active
  end
end
