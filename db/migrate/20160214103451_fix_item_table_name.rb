class FixItemTableName < ActiveRecord::Migration
  def change
    drop_table :item if ActiveRecord::Base.connection.table_exists? :item
    drop_table :items if ActiveRecord::Base.connection.table_exists? :items

    create_table :items do |t|
      t.belongs_to :page, index: true
      t.string :title
      t.string :description
      t.string :img
      t.string :link
      t.integer :status, :limit => 1
    end
  end
end
