class AddDbFields < ActiveRecord::Migration
  def change
    add_column :categories, :img, :string

    add_column :slider_images, :sub_header, :string
  end
end
