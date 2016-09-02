class ItemToColumn < ActiveRecord::Base
  belongs_to :item
  belongs_to :column
  belongs_to :page
end
