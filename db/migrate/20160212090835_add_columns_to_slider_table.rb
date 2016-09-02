class AddColumnsToSliderTable < ActiveRecord::Migration
  def change
    drop_table :sliders if ActiveRecord::Base.connection.table_exists? :sliders

    create_table :sliders do |t|
      t.string :name
      t.integer :height
      t.integer :speed
      t.integer :duration
    end
  end
end
