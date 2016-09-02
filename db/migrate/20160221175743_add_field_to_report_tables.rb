class AddFieldToReportTables < ActiveRecord::Migration
  def change
    drop_table :report_columns if ActiveRecord::Base.connection.table_exists? :report_columns
    drop_table :report_items if ActiveRecord::Base.connection.table_exists? :report_items

    create_table :report_columns do |t|
      t.belongs_to :column, index: true
      t.belongs_to :page, index: true
      t.string :name
      t.string :reason
      t.timestamps
    end

    create_table :report_items do |t|
      t.belongs_to :item, index: true
      t.belongs_to :page, index: true
      t.string :title
      t.string :reason
      t.timestamps
    end
  end
end
