class PageToFolder < ActiveRecord::Base
  belongs_to :page
  belongs_to :folder
end
