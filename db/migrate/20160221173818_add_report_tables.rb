class AddReportTables < ActiveRecord::Migration
  def change
    drop_table :comments if ActiveRecord::Base.connection.table_exists? :comments

    create_table :report_columns do |t|
      t.belongs_to :column, index: true
      t.string :name
      t.string :reason
      t.timestamps
    end

    create_table :report_items do |t|
      t.belongs_to :item, index: true
      t.string :title
      t.string :reason
      t.timestamps
    end

    create_table :comments do |t|
      t.integer :page_id
      t.string  :name
      t.string  :message
      t.boolean :status
      t.timestamps
    end
  end
end
