class RenameDateColumnsToTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :plan_date, :plan_at
    rename_column :tasks, :actual_date, :actual_at
  end
end
