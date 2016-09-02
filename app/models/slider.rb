class Slider < ActiveRecord::Base
  has_many :slider_images, dependent: :destroy
  has_many :pages
end
