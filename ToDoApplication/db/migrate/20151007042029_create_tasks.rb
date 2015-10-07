class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title, null:false
      t.string :content, null:false
      t.datetime :plandate, null:false
      t.datetime :actualdate, null:false

      t.timestamps
    end
  end
end
