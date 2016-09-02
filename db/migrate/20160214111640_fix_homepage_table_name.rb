class FixHomepageTableName < ActiveRecord::Migration
  def change
    drop_table :homepage if ActiveRecord::Base.connection.table_exists? :homepage
    drop_table :homepages if ActiveRecord::Base.connection.table_exists? :homepages

    create_table :homepages do |t|
      t.belongs_to :category, index: true
      t.belongs_to :page, index: true
      t.integer :page_order
    end
  end
end
