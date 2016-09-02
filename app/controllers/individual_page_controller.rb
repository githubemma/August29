class IndividualPageController < ApplicationController
  respond_to :html, :json, :js, :xml

  def index
    slug = params[:id]
    page = Page.find_by(:slug => slug)

    if page
      @page_id = page.id
    else
      @page_id = slug
      Page.find_each(&:save)
      redirect_to :controller => 'welcome', :action => 'index'
    end

    @columns = get_columns(@page_id)
    @description = page.description

    if @columns.length == 0
      redirect_to :controller => 'welcome', :action => 'index'
    end

    @title = page.title
    @image = page.img

    @items = get_item(@page_id)
    @comments = get_comments(@page_id)
    @slider = get_slider(@page_id)
    @twitter_feed = get_twitter_feed(@page_id)
    @links = get_links(@page_id)
    @articles = get_articles
    @similar_pages = get_category_pages(@page_id)
    @bookmark_pages = get_bookmark_pages
    @bookmark_categories = get_bookmark_categories
    @bookmark_category_pages = get_bookmark_category_pages

    if @slider
      @slider_images = get_slider_images(@slider.id)
    end

  end

  def send_message
    if params[:page_id].present?
      c = Comment.new
      c.page_id = params[:page_id]
      c.name = params[:name]
      c.message = params[:message]
      c.status = false # new
      c.save!
    end

    respond_to do |format|
      format.html { render :partial => 'comment/comment', :object => c }
    end
  end

  def suggest_column
    @response = {}

    page_id = params[:page_id].to_i

    if page_id
      new_column = Column.create(name: params[:name], status: 2)
      @response['new_column'] = new_column

      if new_column
        column = ColumnToPage.new
        column.page_id = page_id
        column.column_id = new_column.id
        column.save!
        @response['column'] = column
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def suggest_item
    @response = {}
    @response['params'] = params

    column_id = params[:column_id]
    page_id = params[:page_id]

    data = {
        page_id: page_id,
        title: params[:title],
        description: params[:description],
        link: params[:link],
        img: params[:img],
        status: 2 # suggest
    }

    if page_id && column_id
      new_item = Item.create(data)
      @response['new_item'] = new_item

      if new_item
        item = ItemToColumn.new
        item.page_id = page_id
        item.column_id = column_id
        item.item_id = new_item.id
        item.save!
        @response['item'] = item
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def report_content
    @response = {}
    @response['params'] = params

    page_id = params[:page_id]
    type = params[:type]

    if type == 'item'
      item = ReportItem.new
      item.page_id = page_id
      item.item_id = params[:item_id]
      item.name = params[:name]
      item.reason = params[:reason]
      item.save!
    else
      column = ReportColumn.new
      column.page_id = page_id
      column.column_id = params[:column_id]
      column.name = params[:name]
      column.reason = params[:reason]
      column.save!
    end

    respond_to do |format|
      format.json { render :json => @response }
    end

  end

  def add_bookmark
    @response = {}
    page = false

    if current_user
      page_id = params[:page_id].to_i
      user_id = current_user.id

      exist = Bookmark.find_by('user_id = ? AND page_id = ?', user_id, page_id)

      if exist
        #
      else
        bookmark = Bookmark.new
        bookmark.page_id = page_id
        bookmark.user_id = user_id
        bookmark.save!

        page = Page.find_by(id: page_id)
      end
    end

    respond_to do |format|
      if page
        format.html { render :partial => 'individual_page/bookmark',  :locals => {page: page} }
      else
        format.json { render :json => @response }
      end
    end
  end

  def remove_bookmark
    @response = {}

    if current_user
      page_id = params[:page_id].to_i
      user_id = current_user.id

      exist = Bookmark.find_by('user_id = ? AND page_id = ?', user_id, page_id)

      if exist
        exist.destroy
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def share_by_email
    @response = {}
    @response['params'] = params

    page_id = params[:page_id].to_i
    email = params[:email]

    if current_user && page_id && email
      page = get_page(page_id)
      slider = get_slider(page_id)
      slider_images = get_slider_images(slider.id).take(1)

      email_log = UserEmailLog
                      .where(:user_id => current_user.id, :created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day))

      if email_log.length >= 5
        @response['error'] = 'You have reached your daily limit!'
      else
        template = view_context.render :partial => 'individual_page/share_email',  :locals => {
            page_title: page.title ? page.title : '',
            page_sub_title: page.description ? page.description : '',
            page_description: params[:description] ? params[:description] : '',
            page_image: slider_images ? slider_images[0].img.mobile_banner.url : '',
            page_link: page.slug ? 'http://www.belainfo.com/' + page.slug : 'http://www.belainfo.com/page/' +  page.id,
            page_columns: get_columns(page_id)
        }

        client = Postmark::ApiClient.new('4f373511-bdb0-49af-9e5d-fd465842f5b5')
        client.deliver(
            from: 'contact@belainfo.com',
            to: email,
            #subject: 'Bela Info',
            subject: page.title ? page.title : 'Bela Info',
            html_body: template,
            track_opens: true
        )

        @response['success'] = 'Sent!'
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  private

  def get_comments(page_id)
    Comment.where('page_id = ? AND status = ?', page_id, true).order('id ASC')
  end

  def get_columns(page_id)
    Column.joins(:column_to_pages)
        .select('columns.*, column_to_pages.column_order')
        .where('columns.status = ? AND column_to_pages.page_id = ?', 1, page_id)
        .order('column_to_pages.column_order ASC')
  end

  def get_item(page_id)
    items = Item.joins(:item_to_columns)
                .select('items.*, item_to_columns.item_order, item_to_columns.column_id')
                .where('items.status = ? AND item_to_columns.page_id = ?', 1, page_id)
                .order('item_to_columns.column_id, item_to_columns.item_order ASC')

    col_items = {}
    items.each do |i|
      col_items[i.column_id] = {}
    end

    items.each do |i|
      col_items[i.column_id][i.id] = i
    end

    col_items
  end

  def get_page(page_id)
    Page.find_by(:id => page_id)
  end

  def get_slider(page_id)
    Slider.joins(:pages).select('sliders.*').find_by('pages.id' => page_id)
  end

  def get_twitter_feed(page_id)
    TwitterFeed.find_by(:page_id => page_id)
  end

  def get_slider_images(slider_id, limit = false)
    SliderImage.joins(:slider)
        .select('sliders.*, slider_images.title, slider_images.img, slider_images.sub_header, slider_images.source')
        .limit(limit)
        .where('sliders.id' => slider_id)
        .order('slider_images.id')
  end

  def get_links(page_id)
    QuickLink.where('status = ? AND page_id = ?', 1, page_id)
  end

  def get_articles()
    Article.where(:status => 1)
  end

  def get_category_pages(page_id)
    Page.joins(:homepage)
        .select('pages.title, pages.id, pages.slug, homepages.page_order')
        .where(
            'pages.id != ? AND homepages.category_id IN (?)',
            page_id,
            Homepage.select(:category_id).where(:page_id => page_id)
        )
        .group('pages.id, homepages.page_id, homepages.page_order')
        .order('homepages.page_order')
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
