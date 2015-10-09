class ChangeDatattypeContent < ActiveRecord::Migration
  def change
    change_column :tasks, :content, :text
  end
end
