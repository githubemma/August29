class AddFieldToItemToColumnsTable < ActiveRecord::Migration
  def change
    drop_table :item_to_columns if ActiveRecord::Base.connection.table_exists? :item_to_columns

    create_table :item_to_columns do |t|
      t.belongs_to :item, index: true
      t.belongs_to :column, index: true
      t.belongs_to :category, index: true
      t.integer :item_order
    end
  end
end
