class AddColumnTagToPage < ActiveRecord::Migration
  def change
    add_column :pages, :tag, :string, :limit => 255
  end
end
