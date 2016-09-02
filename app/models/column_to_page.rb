class ColumnToPage < ActiveRecord::Base
  belongs_to :column
  belongs_to :page
end
