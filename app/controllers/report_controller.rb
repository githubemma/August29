class ReportController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @items = Item.joins(:report_items)
                 .joins(:columns)
                 .joins(:page)
                 .select('items.*, items.id AS item_id, report_items.*, columns.name AS col_name, pages.title AS page_title, pages.slug')
                 .order('created_at DESC')

    @columns = ReportColumn.joins(:column)
                   .joins(:page)
                   .select('report_columns.*, columns.id AS col_id, columns.name AS col_name, pages.title, pages.slug')

    @histories = ReportHistory.order('created_at DESC').all
  end

  def delete
    @response = {}

    type = params[:type]
    item_id = params[:item_id]
    page_id = params[:page_id]
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

    history = delete_history(page_id, type, title)
    @response['history'] = history.history
    @response['created_at'] = history.created_at.strftime('%d-%m-%Y %H:%M')

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def ignore
    @response = {}

    type = params[:type]
    item_id = params[:item_id]
    page_id = params[:page_id]
    column_id = params[:column_id]

    if type == 'item'
      report_item = ReportItem.find_by(item_id: item_id)
      if report_item
        item = Item.find_by(id: item_id)
        title = 'Item: <b>' + item.title + '</b>'
        report_item.destroy
      end
    else
      report_column = ReportColumn.find_by(column_id: column_id)
      if report_column
        column = Column.find_by(id: column_id)
        title = 'Column: <b>' + column.name + '</b>'
        report_column.destroy
      end
    end

    history = ignore_history(page_id, type, title)
    @response['history'] = history.history
    @response['created_at'] = history.created_at.strftime('%d-%m-%Y %H:%M')

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def clear_history
    @response = {}

    if params[:clear_history]
      ReportHistory.delete_all
    end

    @response['report'] = params[:clear_history]

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

  def delete_history(page_id, type, title)
    page_title = get_page_title(page_id, type)

    content = 'Page: <a href="/page/' + page_id + '">' + page_title + '</a>. ' + title + '. <span class="clr-green">Deleted</span>'
    history = ReportHistory.create(history: content)
    history
  end

  def ignore_history(page_id, type, title)
    page_title = get_page_title(page_id, type)

    content = 'Page: <a href="/page/' + page_id + '">' + page_title + '</a>. ' + title + '. <span class="clr-red">Ignored</span>'
    history = ReportHistory.create(history: content)
    history
  end
end
