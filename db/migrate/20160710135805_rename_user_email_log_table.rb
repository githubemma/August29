class RenameUserEmailLogTable < ActiveRecord::Migration
  def change
    drop_table :user_email_log if ActiveRecord::Base.connection.table_exists? :user_email_log

    create_table :user_email_logs do |t|
      t.belongs_to :user, index: true
      t.string :email
      t.timestamps
    end

  end
end
