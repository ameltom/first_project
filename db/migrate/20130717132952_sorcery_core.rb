class SorceryCore < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :username,         :null => false  # if you use another field as a username, for example email, you can safely remove this field.
      t.string :crypted_password, :default => nil
      t.string :salt,             :default => nil
    end
  end

  def self.down
    drop_table :users
  end
end