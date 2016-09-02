class HomepageController < ApplicationController
  #include Devise::Controllers::Helpers
  before_filter :authenticate_admin!

  respond_to :html, :json, :js, :xml

  def index
    @categories = Category.all
    @pages = Page.where('id != 0')
  end

  def get_homepage_content
    @response = {}

    @response['pages'] = Page.joins(:homepage)
                      .select('pages.*, homepages.page_order, homepages.category_id')
                      .where('pages.id != 0')
                      .order('page_order')

    @response['categories'] = HomepageCategory.joins(:category)
                      .select('categories.*, homepage_categories.category_order')
                      .order('category_order')

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def save_homepage_content
    @response = {}
    categories = params['categories']

    if categories
      HomepageCategory.destroy_all
      Homepage.destroy_all

      categories.each do |key, value|
        category = HomepageCategory.new
        category.category_id = value['category_id']
        category.category_order = value['category_order']
        category.save!

        if value['pages']
          value['pages'].each do |k, v|
            page = Homepage.new
            page.category_id = v[:category_id]
            page.page_id = v[:page_id]
            page.page_order = v[:page_order]
            page.save!
          end
        end
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  #----------- Category -------------

  def save_category
    @response = {}

    @response['params'] = params

    data = {
        name: params[:name],
        img: params[:img]
    }

    # Update
    if params[:category_id].present?
      category = Category.find_by(id: params[:category_id])
      category.update(data)
      @response['category'] = category
    elsif params[:name].present? # Insert
      category = Category.create(data)
      @response['new'] = true
      @response['category'] = category
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_category
    @response = {}

    if params[:category_id].present?
      category = Category.find_by(id: params[:category_id])
      if category
        category.destroy
        @response['category_id'] = params[:category_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

end
