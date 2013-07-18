class UsersAddStatus < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :status
    end
  end
end
