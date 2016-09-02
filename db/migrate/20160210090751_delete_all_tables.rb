class DeleteAllTables < ActiveRecord::Migration
  def change
    drop_table :item if ActiveRecord::Base.connection.table_exists? :item
    drop_table :categories if ActiveRecord::Base.connection.table_exists? :categories
    drop_table :columns if ActiveRecord::Base.connection.table_exists? :columns
    drop_table :sliders if ActiveRecord::Base.connection.table_exists? :slider
    drop_table :slider_images if ActiveRecord::Base.connection.table_exists? :slider_images
    drop_table :column_to_categories if ActiveRecord::Base.connection.table_exists? :column_to_categories
    drop_table :homepage_categories if ActiveRecord::Base.connection.table_exists? :homepage_categories
    drop_table :homepage_items if ActiveRecord::Base.connection.table_exists? :homepage_items
    drop_table :item_to_columns if ActiveRecord::Base.connection.table_exists? :item_to_columns
  end
end
