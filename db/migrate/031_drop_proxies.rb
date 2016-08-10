class DropProxies < ActiveRecord::Migration
  def change
    drop_table :proxies
  end
end
