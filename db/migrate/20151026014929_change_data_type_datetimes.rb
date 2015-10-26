class ChangeDataTypeDatetimes < ActiveRecord::Migration
  def change
    change_column :tasks, :plan_at, :date
    change_column :tasks, :actual_at, :date
  end
end
