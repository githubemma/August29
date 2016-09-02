class FixColName < ActiveRecord::Migration
  def change
    remove_column :report_items, :title

    add_column :report_items, :name, :string
  end
end
