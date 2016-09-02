class ReportColumn < ActiveRecord::Base
  belongs_to :page
  belongs_to :column
end
