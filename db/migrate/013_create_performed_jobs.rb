class CreatePerformedJobs < ActiveRecord::Migration
  def change
    create_table :performed_jobs do |t|
      t.string :type, null: false
      t.string :key, null: false
      t.integer :status, null: false, default: 0
      t.integer :performs, null: false, default: 0
      t.timestamps null: false
    end

    add_index :performed_jobs, [:type, :key], unique: true
  end
end
