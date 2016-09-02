class SliderImage < ActiveRecord::Base
  belongs_to :slider

  mount_uploader :img, ImageUploader

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_update :crop_image

  def crop_image
    img.recreate_versions! if crop_x.present?
  end
end
