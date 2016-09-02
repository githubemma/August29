class ContentController < ApplicationController
  before_filter :authenticate_admin!

  respond_to :html, :json, :js, :xml

  def index
    # get all items
    @items = Item.joins('LEFT JOIN pages p ON p.id = items.page_id')
                 .joins('LEFT JOIN item_to_columns i2c ON p.id = i2c.page_id AND i2c.item_id = items.id')
                 .joins('LEFT JOIN columns c ON c.id = i2c.column_id')
                 .select('items.*, p.id AS pid, p.title AS page_title, c.name as column_name, c.id AS cid')
                 .where(status: 1)
                 .order('pid ASC, c.name ASC, items.id ASC')

    respond_to do |format|
      format.html
    end
  end

  def export_content
    @items = Item.all
    @response = {}

    if params[:items]
      respond_to do |format|
        format.csv { send_data @items.to_csv(params[:items]), :filename => 'items.csv' }
      end
    else
      respond_to do |format|
        format.json { render :json => @response }
      end
    end
  end

  def import_content
    if params[:file]
      Item.import(params[:file])
      redirect_to '/admin/content', notice: 'Items imported'
    else
      redirect_to '/admin/content', notice: 'Please select a CSV file!'
    end
  end

  def delete_content
    @response = {}

    if params[:items].present?

      params[:items].each do |i|
        item = Item.find_by(id: i)
        if item
          item.destroy
        end
      end

      @response['success'] = true
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

end