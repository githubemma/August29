class FixColumnToPageTableName < ActiveRecord::Migration
  def change
    drop_table :column_to_page if ActiveRecord::Base.connection.table_exists? :column_to_page
    drop_table :column_to_page if ActiveRecord::Base.connection.table_exists? :column_to_pages

    create_table :column_to_pages do |t|
      t.belongs_to :column, index: true
      t.belongs_to :page, index: true
      t.integer :column_order
    end
  end
end
