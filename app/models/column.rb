class Column < ActiveRecord::Base
  has_many :items, through: :item_to_columns
  has_many :pages, through: :column_to_pages
  has_many :column_to_pages, dependent: :destroy
  has_many :item_to_columns, dependent: :destroy
  has_many :report_columns, dependent: :destroy
end
