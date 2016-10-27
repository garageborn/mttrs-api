class DropPerformedJobs < ActiveRecord::Migration[5.0]
  def change
    drop_table :performed_jobs
  end
end
