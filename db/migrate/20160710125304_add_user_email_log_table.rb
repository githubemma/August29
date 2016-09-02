class AddUserEmailLogTable < ActiveRecord::Migration
  def change

    create_table :user_email_log do |t|
      t.belongs_to :user, index: true
      t.string :email
      t.timestamps
    end

  end
end
