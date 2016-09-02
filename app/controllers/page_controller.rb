class PageController < ApplicationController
  before_filter :authenticate_admin!

  respond_to :html, :json, :js, :xml

  def index
    # @pages = Page.where('id != 0').order('id ASC')

    @columns = Column.order('id ASC').all
    @folders = Folder.order('id DESC').all

    @pages = {}
    pages = Page.joins('LEFT JOIN page_to_folders AS p2f ON p2f.page_id = pages.id')
                .select('pages.*, p2f.folder_id')
                .where('pages.id != 0')
                .order('pages.id ASC')

    @folder_pages = {}

    pages.each do |p|
      if p.folder_id
        @folder_pages[p.folder_id] = {}
      end
    end

    pages.each do |p|
      if p.folder_id
        @folder_pages[p.folder_id][p.id] = p
      else
        @pages[p.id] = p
      end
    end

  end

  #----------- Page -------------

  def save_page
    @response = {}
    @response['params'] = params

    data = {
        title: params[:title],
        description: params[:description],
        img: params[:img],
        tag: params[:tag]
    }

    if params[:page_id].present? # Update
      page = Page.find_by(id: params[:page_id])
      page.update(data)
      @response['page'] = page
    elsif params[:title].present? # Insert
      page = Page.create(data)
      @response['new'] = true
      @response['page'] = page
    end

    # Update slug
    if page
      page.slug = nil
      page.save!
      @response['update_page'] = page
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_page
    @response = {}
    @response['params'] = params

    if params[:page_id].present?
      page = Page.find_by(id: params[:page_id])
      if page
        page.destroy
        @response['page_id'] = params[:page_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def save_page_content
    @response = {}

    page_id = params[:page_id]
    columns = params[:columns]

    if page_id && columns
      ColumnToPage.destroy_all(:page_id => page_id)
      ItemToColumn.destroy_all(:page_id => page_id)

      columns.each do |key, value|
        column = ColumnToPage.new
        column.page_id = page_id
        column.column_id = value['column_id']
        column.column_order = value['column_order']
        column.save!

        if value['items']
          value['items'].each do |k, v|
            item = ItemToColumn.new
            item.page_id = page_id
            item.column_id = v[:column_id]
            item.item_id = v[:item_id]
            item.item_order = v[:item_order]
            item.save!
          end
        end
      end
    end

    @response['columns'] = columns

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def get_page_content
    @response = {}

    @response['items'] = Item.where('status = ? AND page_id = ?', 1, params[:id]).order('id ASC')

    @response['columns'] = ColumnToPage.joins(:column)
                               .select('columns.*, column_to_pages.column_order')
                               .where('columns.status = ? AND column_to_pages.page_id = ?', 1, params[:id])
                               .order('column_to_pages.column_order')

    @response['column_items'] = Item.joins(:item_to_columns)
                                    .select('items.*, item_to_columns.item_order, item_to_columns.column_id')
                                    .where('items.page_id' => params[:id])
                                    .order('item_to_columns.column_id, item_to_columns.item_order')

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  #----------- Column -------------

  def save_column
    @response = {}

    data = {
        name: params[:name],
        status: (params[:status].empty?) ? 1 : params[:status]
    }

    if params[:column_id].present? # Update
      column = Column.find_by(id: params[:column_id])
      column.update(data)
      @response['column'] = column
    elsif params[:name].present? # Insert
      column = Column.create(data)
      @response['new'] = true
      @response['column'] = column
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_column
    @response = {}

    if params[:column_id].present?
      column = Column.find_by(id: params[:column_id])
      if column
        column.destroy
        @response['column_id'] = params[:column_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  #----------- Item -------------

  def save_item
    @response = {}
    @response['params'] = params

    data = {
        page_id: params[:page_id],
        title: params[:title],
        description: params[:description],
        link: params[:link],
        img: params[:img],
        status: (params[:status].empty?) ? 1 : params[:status]
    }

    if params[:item_id].present? #Update
      item = Item.find_by(id: params[:item_id])
      item.update(data)
      @response['item'] = item
    elsif params[:page_id].present? # Insert
      item = Item.create(data)
      @response['new'] = true
      @response['item'] = item
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_item
    @response = {}

    if params[:item_id].present?
      item = Item.find_by(id: params[:item_id])
      if item
        item.destroy
        @response['item_id'] = params[:item_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  #------- Copy Item ---------

  def get_item_pages
    @response = {}
    @response['params'] = params

    if params[:page_id].present?
      @response['pages'] = Page.where('pages.id != ? AND pages.id != ?', 0, params[:page_id]).order('id ASC')
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def copy_item
    @response = {}

    @response['params'] = params
    @response['add_pages'] = {}

    if params[:item_id].present?
      item = Item.find_by(id: params[:item_id])
      @response['item'] = item
      @response['img'] = item.img.url

      if item

        # copy item
        params[:pages].each do |id|
          copy_item = item.dup
          copy_item.img = item.img
          copy_item.page_id = id
          copy_item.save

          @response['add_pages'][id] = copy_item
        end
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  #------- Twitter feed ---------

  def get_twitter_feed
    @response = {}

    @response['twitter_feed'] = TwitterFeed.find_by(:page_id => params[:page_id])

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def save_twitter_feed
    @response = {}

    @response['params'] = params

    data = {
        page_id: params[:page_id],
        title: params[:title],
        widget: params[:widget],
        hashtag: params[:hashtag]
    }

    if params[:twitter_feed_id].present? # Update
      twitter_feed = TwitterFeed.find_by(id: params[:twitter_feed_id])
      twitter_feed.update(data)
      @response['twitter_feed'] = twitter_feed
    elsif params[:page_id].present? # Insert
      twitter_feed = TwitterFeed.create(data)
      @response['new'] = true
      @response['twitter_feed'] = twitter_feed
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_twitter_feed
    @response = {}

    if params[:twitter_feed_id].present?
      twitter_feed = TwitterFeed.find_by(id: params[:twitter_feed_id])
      if twitter_feed
        twitter_feed.destroy
        @response['twitter_feed_id'] = params[:twitter_feed_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  #------- Quick Links ---------

  def get_links
    @response = {}

    @response['links'] = QuickLink.where(:page_id => params[:page_id]).order('id ASC')

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def save_quick_links
    @response = {}

    page_id = params[:page_id]
    links = params[:links]

    if links
      links.each do |k, v|
        exists = QuickLink.find_by(id: k)
        if exists
          exists.update(
              text: v[:text],
              link: v[:link],
              status: v[:status]
          )
        else
          QuickLink.create(
              page_id: page_id,
              text: v[:text],
              link: v[:link],
              status: v[:status]
          )
        end
      end
    end

    @response['links'] = links
    @response['page_id'] = page_id

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_quick_link
    @response = {}

    if params[:link_id].present?
      link = QuickLink.find_by(id: params[:link_id])
      if link
        link.destroy
        @response['link_id'] = params[:link_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  #------------- Folder -------------

  def save_folder
    @response = {}
    @response['params'] = params

    data = {
        name: params[:name]
    }

    if params[:folder_id].present? # Update
      folder = Folder.find_by(id: params[:folder_id])
      folder.update(data)
      @response['folder'] = folder
    elsif params[:name].present? # Insert
      folder = Folder.create(data)
      @response['new'] = true
      @response['folder'] = folder
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_folder
    @response = {}
    @response['params'] = params

    if params[:folder_id].present?
      folder = Folder.find_by(id: params[:folder_id])
      if folder
        folder.destroy
        @response['folder_id'] = params[:folder_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def add_page_to_folder
    @response = {}
    @response['params'] = params

    if params[:folder_id].present? && params[:page_id].present?
      page_to_folder = PageToFolder.create({page_id: params[:page_id], folder_id: params[:folder_id]})

      @response['page_to_folder'] = page_to_folder
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def remove_page_from_folder
    @response = {}
    @response['params'] = params

    if params[:folder_id].present? && params[:page_id].present?
      page_to_folder = PageToFolder
                           .where('folder_id = ? AND page_id = ?', params[:folder_id], params[:page_id])
      if page_to_folder
        page_to_folder.destroy_all
      end

      @response['page_to_folder'] = page_to_folder
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

end