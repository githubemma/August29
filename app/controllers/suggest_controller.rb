class SuggestController < ApplicationController
  before_filter :authenticate_admin!

  respond_to :html, :json, :js, :xml

  def index
    @items = Item.joins('LEFT JOIN item_to_columns AS i2c ON i2c.item_id = items.id')
                 .joins('LEFT JOIN columns AS c ON i2c.column_id = c.id')
                 .joins('LEFT JOIN pages AS p ON p.id = items.page_id')
                 .select('items.*, c.name AS column_name, c.status AS column_status,
                     p.title AS page_title, p.id AS page_id, p.slug')
                 .where('items.status = 2')
                 .order('items.id DESC')

    @columns = Column.joins(:column_to_pages)
                  .joins(:pages)
                  .select('columns.*, pages.title AS page_title, pages.id AS page_id, pages.slug')
                  .where('columns.status = 2')
                  .order('columns.id DESC')

    @histories = SuggestHistory.order('created_at DESC').all
  end

  def accept_all
    @response = {}

    if params[:do_action]
      Item.where(status: 2).update_all(status: 1)
      Column.where(status: 2).update_all(status: 1)
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def decline_all
    @response = {}
    @response['do_action'] = params[:do_action]

    if params[:do_action]
      Item.delete_all(status: 2)
      Column.delete_all(status: 2)
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def accept
    @response = {}

    type = params[:type]
    page_id = params[:page_id]
    item_id = params[:item_id]
    column_id = params[:column_id]

    @response['type'] = type
    @response['item_id'] = item_id
    @response['column_id'] = column_id

    if type == 'item'
      item = Item.find_by(id: item_id)
      if item
        item.update(:status => 1)
        title = 'Item: <b>' + item.title + '</b>'
      end
    else
      column = Column.find_by(id: column_id)
      if column
        column.update(:status => 1)
        title = 'Column: <b>' + column.name + '</b>'
      end
    end

    history = accept_history(page_id, type, title)
    @response['history'] = history.history
    @response['created_at'] = history.created_at.strftime('%d-%m-%Y %H:%M')

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def decline
    @response = {}

    type = params[:type]
    page_id = params[:page_id]
    item_id = params[:item_id]
    column_id = params[:column_id]

    if type == 'item'
      item = Item.find_by(id: item_id)
      if item
        title = 'Item: <b>' + item.title + '</b>'
        item.destroy
      end
    else
      column = Column.find_by(id: column_id)
      if column
        title = 'Column: <b>' + column.name + '</b>'
        column.destroy
      end
    end

    history = decline_history(page_id, type, title)
    @response['history'] = history.history
    @response['created_at'] = history.created_at.strftime('%d-%m-%Y %H:%M')

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def clear_history
    @response = {}

    if params[:clear_history]
      SuggestHistory.delete_all
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def get_page_title(page_id, type)
    if type == 'item'
      page = Page.joins(:item_to_columns).select('pages.*').find_by('item_to_columns.page_id' => page_id)
    else
      page = Page.joins(:column_to_pages).select('pages.*').find_by('column_to_pages.page_id' => page_id)
    end

    page.title
  end

  def accept_history(page_id, type, title)
    page_title = get_page_title(page_id, type)

    content = 'Page: <a href="/page/' + page_id + '">' + page_title + '</a>. ' + title + '. <span class="clr-green">Accepted</span>'
    history = SuggestHistory.create(history: content)
    history
  end

  def decline_history(page_id, type, title)
    page_title = get_page_title(page_id, type)

    content = 'Page: <a href="/page/' + page_id + '">' + page_title + '</a>. ' + title + '. <span class="clr-red">Declined</span>'
    history = SuggestHistory.create(history: content)
    history
  end
end
