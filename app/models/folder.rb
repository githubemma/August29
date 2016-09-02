class Folder < ActiveRecord::Base
  has_many :pages, through: :page_to_folders
  has_many :page_to_folders, dependent: :destroy
end
