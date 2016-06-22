class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters do |t|
      t.timestamps null: false
    end
  end
end
