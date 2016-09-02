class AddSourceFieldToSliderImages < ActiveRecord::Migration
  def change
    add_column :slider_images, :source, :string, :limit => 255
  end
end
