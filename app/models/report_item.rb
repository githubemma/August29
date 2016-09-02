class ReportItem < ActiveRecord::Base
  belongs_to :page
  belongs_to :item
end
