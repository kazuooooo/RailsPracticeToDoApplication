class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :content
      t.datetime :plan_date
      t.datetime :actual_date

      t.timestamps null: false
    end
  end
end
