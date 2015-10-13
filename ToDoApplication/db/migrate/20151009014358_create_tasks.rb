class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :content
      t.datetime :plan_at
      t.datetime :actual_at

      t.timestamps null: false
    end
  end
end
