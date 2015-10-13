class RenameDateColumnsToTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :plan_at, :plan_at
    rename_column :tasks, :actual_at, :actual_at
  end
end
