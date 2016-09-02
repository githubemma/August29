class FixCommentsTable < ActiveRecord::Migration
  def change
    drop_table :comment if ActiveRecord::Base.connection.table_exists? :comment
    drop_table :comments if ActiveRecord::Base.connection.table_exists? :comments

    create_table :comments do |t|
      t.belongs_to :page, index: true
      t.string :name
      t.string :message
    end
  end
end
