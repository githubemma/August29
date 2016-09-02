class HomepageCategory < ActiveRecord::Base
  belongs_to :category
  has_many :homepages

  accepts_nested_attributes_for :homepages, :reject_if => :all_blank, :allow_destroy => true
end
