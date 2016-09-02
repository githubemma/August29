class ReshuffleDb < ActiveRecord::Migration
  def change
    drop_table :item if ActiveRecord::Base.connection.table_exists? :item
    drop_table :categories if ActiveRecord::Base.connection.table_exists? :categories
    drop_table :columns if ActiveRecord::Base.connection.table_exists? :columns
    drop_table :sliders if ActiveRecord::Base.connection.table_exists? :sliders
    drop_table :slider_images if ActiveRecord::Base.connection.table_exists? :slider_images
    drop_table :column_to_categories if ActiveRecord::Base.connection.table_exists? :column_to_categories
    drop_table :homepage_categories if ActiveRecord::Base.connection.table_exists? :homepage_categories
    drop_table :homepage_items if ActiveRecord::Base.connection.table_exists? :homepage_items
    drop_table :item_to_columns if ActiveRecord::Base.connection.table_exists? :item_to_columns

    create_table :pages do |t|
      t.belongs_to :slider, index: true
      t.string :title
      t.string :description
      t.string :img
    end

    create_table :categories do |t|
      t.string :name
    end

    create_table :item do |t|
      t.belongs_to :page, index: true
      t.string :title
      t.string :description
      t.string :img
      t.string :link
      t.integer :status, :limit => 1
    end

    create_table :sliders do |t|
      t.string :name
      t.integer :height
      t.integer :speed
      t.integer :duration
      t.boolean :default
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

    create_table :column_to_page do |t|
      t.belongs_to :column, index: true
      t.belongs_to :page, index: true
      t.integer :column_order
    end

    create_table :homepage_categories do |t|
      t.belongs_to :category, index: true
      t.integer :category_order
    end

    create_table :homepage do |t|
      t.belongs_to :category, index: true
      t.belongs_to :page, index: true
      t.integer :page_order
    end

    create_table :item_to_columns do |t|
      t.belongs_to :item, index: true
      t.belongs_to :column, index: true
      t.integer :item_order
    end

    create_table :users do |t|
      t.string :login
      t.string :name
      t.string :password
    end

    create_table :comments do |t|
      t.string :login
      t.string :name
      t.string :password
    end
  end
end
