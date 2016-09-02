# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick
  include Cloudinary::CarrierWave

  #storage :file
  # storage :fog

  # def store_dir
  #   # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/"
  # end
  #
  # def cache_dir
  #   "uploads/tmp/#{model.class.to_s.underscore}/#{mounted_as}/"
  # end

  version :banner, :if => :is_banner? do
    # process :eager => true

    process :crop
    cloudinary_transformation :effect => "sharpen:50"
  end

  version :share_banner, :if => :is_banner? do
    cloudinary_transformation :transformation=>[
        {:width=>600, :height=>315, :gravity=>"face", :crop=>"crop"}
    ]

    cloudinary_transformation :effect => "sharpen:50"
  end

  version :tab_banner, :if => :is_banner? do
    cloudinary_transformation :transformation=>[
        {:width=>1024, :height=>220, :gravity=>"face", :crop=>"crop"}
    ]

    cloudinary_transformation :effect => "sharpen:50"
  end

  version :mobile_banner, :if => :is_banner? do
    cloudinary_transformation :transformation=>[
        {:width=>600, :height=>180, :crop=>"crop"}
    ]

    cloudinary_transformation :effect => "sharpen:50"
  end

  version :slide, :if => :is_slider? do
    # process :resize_to_fill => [260, 260]
    # process :resize_to_fill => [260, 0]

    # process :eager => true
    # cloudinary_transformation :transformation => [{:width=>260, :height=>260, :crop=>:mfit}]
    cloudinary_transformation :transformation => [{:width=>260, :crop=>:scale}]
    #resize_to_fit(260, 500)

    cloudinary_transformation :effect => "sharpen:130"
  end

  version :thumb, :if => :is_thumb? do
    # process :resize_to_fill => [150, 0]
    # process :resize_to_fill => [150, 150]

    # process :eager => true
    # cloudinary_transformation :transformation => [{:width=>150, :height=>150, :crop=>:mfit}]
    cloudinary_transformation :transformation => [{:width=>148, :crop=>:scale}]
    # resize_to_fit(200, 200)

    cloudinary_transformation :effect => "sharpen:130"
  end

  # def crop
  #   transformations = []
  #   transformations << { x: model.crop_x, y: model.crop_y, width: model.crop_w, height: model.crop_h, crop: :crop }
  #   transformations << { width: 1000, height: 1000, crop: :fill }
  #   { transformation: transformations }
  # end

  def extension_white_list
    %w(jpg jpeg gif png bmp tif tiff)
  end

  def is_thumb?(new_file)
    model.class.to_s == 'Item'
  end

  def is_slider?(new_file)
    model.class.to_s == 'Page'
  end

  def is_banner?(new_file)
    model.class.to_s == 'SliderImage'
  end

  def crop
    if model.try(:crop_x)
    if model.crop_x.present?

      #resize_to_fill(1000, 0)
      # process :eager => true
      #resize_to_limit(1000, 1000)

      #cloudinary_transformation :transformation => [{:width=>1000, :height=>1000, :crop=>:mfit}]
      cloudinary_transformation :transformation => [{:width=>1000, :crop=>:scale}]

      manipulate! do |img|
        img.crop "#{model.crop_w}x#{model.crop_h}+#{model.crop_x}+#{model.crop_y}"
        #img
      end
    end
    end
  end
end
