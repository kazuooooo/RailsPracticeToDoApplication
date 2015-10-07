class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mailaddress
      t.string :password
      t.string :provider
      t.string :uid
      t.string :facebookId

      t.timestamps
    end
  end
end
