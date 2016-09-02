class Category < ActiveRecord::Base
  has_one :homepage_category, dependent: :destroy
  has_one :homepage, dependent: :destroy

  mount_uploader :img, ImageUploader
end
