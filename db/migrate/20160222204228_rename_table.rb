class RenameTable < ActiveRecord::Migration
  def change

    drop_table :users if ActiveRecord::Base.connection.table_exists? :users

    create_table :admins do |t|
      t.string :email
      t.string :encrypted_password
    end

  end
end
