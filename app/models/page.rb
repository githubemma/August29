class Page < ActiveRecord::Base
  attr_accessor :item_present

  has_one :slider
  has_one :homepage, dependent: :destroy
  has_one :quick_link, dependent: :destroy

  has_many :folders, through: :page_to_folders
  has_many :page_to_folders, dependent: :destroy

  has_many :columns, through: :column_to_pages
  has_many :column_to_pages, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :item_to_columns, dependent: :destroy
  has_many :report_items, dependent: :destroy
  has_many :report_columns, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # upload image for Page
  mount_uploader :img, ImageUploader

  # friendly url
  extend FriendlyId
  friendly_id :title, use: :slugged
end