class WelcomeController < ApplicationController
  respond_to :html, :json, :js
  before_action only: :index

  def index
    @categories = Category.joins(:homepage_category)
                      .select('categories.*, homepage_categories.category_order')
                      .order('homepage_categories.category_order ASC')

    pages = Page.joins(:homepage)
                     .select('pages.*, homepages.page_order, homepages.category_id')

    @pages = {}
    pages.each do |p|
      @pages[p.category_id] = {}
    end

    pages.each do |p|
      @pages[p.category_id][p.id] = p
    end

    @slider = Slider.joins(:pages).select('sliders.*').find_by('pages.id' => 0)

    if @slider
      @slider_images = SliderImage.joins(:slider)
                    .select('sliders.*, slider_images.title, slider_images.img, slider_images.sub_header, slider_images.source')
                    .where('sliders.id' => @slider.id)
                    .order('slider_images.id')
    end

    @articles = Article.where(:status => 1)

    @bookmark_pages = get_bookmark_pages
    @bookmark_categories = get_bookmark_categories
    @bookmark_category_pages = get_bookmark_category_pages
  end

  def request_page
    @response = {}

    r = RequestPage.new
    r.text = params[:text]
    r.save!

    @response['success'] = true

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def get_bookmark_pages
    if current_user
      Page.joins(:bookmarks)
          .where('bookmarks.user_id' => current_user.id)
          .order('bookmarks.id')
    end
  end

  def get_bookmark_categories
    if current_user
      Page.joins('LEFT JOIN bookmarks ON bookmarks.page_id = pages.id')
          .joins('LEFT JOIN homepages ON homepages.page_id = pages.id')
          .joins('LEFT JOIN categories ON categories.id = homepages.category_id')
          .select('categories.name, categories.id')
          .where('bookmarks.user_id' => current_user.id)
          .group('categories.id')
    end
  end

  def get_bookmark_category_pages
    if current_user
      Page.joins('LEFT JOIN bookmarks ON bookmarks.page_id = pages.id')
          .joins('LEFT JOIN homepages ON homepages.page_id = pages.id')
          .joins('LEFT JOIN categories ON categories.id = homepages.category_id')
          .select('pages.id AS page_id, categories.id AS category_id')
          .where('bookmarks.user_id' => current_user.id)
    end
  end
end
