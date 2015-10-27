class ChangeColumnNameOfDates < ActiveRecord::Migration
  def change
    rename_column :tasks, :plan_at, :plan_date
    rename_column :tasks, :actual_at, :actual_date 
  end
end
