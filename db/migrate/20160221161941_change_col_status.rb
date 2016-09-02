class ChangeColStatus < ActiveRecord::Migration
  def change
    remove_column :columns, :status
    remove_column :items, :status

    add_column :columns, :status, :integer, limit: 2, :default => 1
    add_column :items, :status, :integer, limit: 2, :default => 1
  end
end
