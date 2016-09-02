class SliderController < ApplicationController
  before_filter :authenticate_admin!

  respond_to :html, :json, :js, :xml

  def index
    # Add homepage to list of pages with id: 0
    add_homepage

    @sliders = Slider.order('id ASC').all
  end

  def save_slider
    @response = {}
    slider_data = {
        name: params[:name],
        height: params[:height],
        speed: params[:speed],
        duration: params[:duration]
    }

    # Update
    if params[:slider_id].present?
      slider = Slider.find_by(id: params[:slider_id])
      slider.update(slider_data)
      @response['slider'] = slider
    elsif params[:name].present? # Insert
      slider = Slider.create(slider_data)
      @response['new'] = true
      @response['slider'] = slider
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_slider
    @response = {}

    if params[:slider_id].present?
      slider = Slider.find_by(id: params[:slider_id])
      if slider
        slider.destroy
        @response['slider_id'] = params[:slider_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def save_slider_images
    @response = {}
    @response['params'] = params

    slider_id = params[:slider_id]
    images = params[:image]

    if images
      images.each do |k, v|
        exists = SliderImage.find_by(id: k)
        if exists
          exists.update(
              img: v[:img],
              title: v[:title],
              sub_header: v[:sub_header],
              source: v[:source]
          )
        else
          SliderImage.create(
              slider_id: slider_id,
              img: v[:img],
              title: v[:title],
              sub_header: v[:sub_header],
              source: v[:source]
          )
        end
      end
    end

    @response['images'] = images

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_slider_image
    @response = {}

    if params[:image_id].present?
      image = SliderImage.find_by(id: params[:image_id])
      if image
        image.destroy
        @response['image_id'] = params[:image_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def get_images
    @response = {}

    if params[:slider_id].present?
      @response['images'] = SliderImage.where(slider_id: params[:slider_id]).order('id ASC')
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def get_pages
    @response = {}
    @response['pages'] = Page.order('id ASC').all

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def assign_sliders
    @response = {}

    pages = params[:page]
    pages.each do |id, slider_id|
      page = Page.find_by(id: id)
      if page
        page.update(slider_id: slider_id)
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def crop_image
    @response = {}
    @response['params'] = params

    exists = SliderImage.find_by(id: params[:image_id])
    if exists
      exists.update(
          crop_x: params[:crop_x],
          crop_y: params[:crop_y],
          crop_w: params[:crop_w],
          crop_h: params[:crop_h]
      )
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  private
    def add_homepage
      exists = Page.find_by(id: 0)
      if exists
        return
      end
      p = Page.new
      p.id = 0
      p.title = 'Homepage'
      p.save!
    end
end