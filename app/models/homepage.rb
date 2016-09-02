class Homepage < ActiveRecord::Base
  belongs_to :category
  belongs_to :page
  belongs_to :homepage_categories
end
