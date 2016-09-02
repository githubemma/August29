class AddTables < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.belongs_to :slider
      t.string :name
    end

    create_table :item do |t|
      t.belongs_to :category, index: true
      t.string :title
      t.string :description
      t.string :img
      t.string :link
      t.integer :status, :limit => 1
    end

    create_table :sliders do |t|
      t.string :name
    end

    create_table :columns do |t|
      t.string :name
      t.string :status
    end

    create_table :slider_images do |t|
      t.belongs_to :slider, index: true
      t.string :title
      t.string :img
    end

    create_table :column_to_categories do |t|
      t.belongs_to :column, index: true
      t.belongs_to :category, index: true
      t.integer :column_order
    end

    create_table :homepage_categories do |t|
      t.belongs_to :category, index: true
      t.integer :category_order
    end

    create_table :homepage_items do |t|
      t.belongs_to :category, index: true
      t.belongs_to :item, index: true
      t.integer :item_order
    end

    create_table :item_to_columns do |t|
      t.belongs_to :item, index: true
      t.belongs_to :column, index: true
      t.integer :category_order
    end
  end
end
