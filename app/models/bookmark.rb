class Bookmark < ActiveRecord::Base
  has_many :users, through: :bookmarks
  has_many :pages, through: :bookmarks
end
