class DropNamespacesAssociations < ActiveRecord::Migration
  def change
    drop_table :feeds_namespaces
    drop_table :categories_namespaces
    drop_table :links_namespaces
  end
end
