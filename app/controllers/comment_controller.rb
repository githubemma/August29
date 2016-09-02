class CommentController < ApplicationController
  before_filter :authenticate_admin!

  def index
    comments = Comment.joins(:page)
          .select('comments.*, pages.title')
          .order('comments.created_at DESC')

    @comments = {}

    comments.each do |c|
      day = c.created_at.strftime('%Y-%m-%d')
      @comments[day] = {}
    end

    comments.each do |c|
      day = c.created_at.strftime('%Y-%m-%d')
      @comments[day][c.id] = c
    end

    @request_pages = RequestPage.all
  end

  def change_status
    @response = {}
    comments = Comment.where("date_trunc('day', created_at) = '#{params[:date]}'")
                   .update_all(:status => true)

    @response['comments'] = comments

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def edit_comment
    @response = {}

    if params[:comment_id].present?
      comment = Comment.find_by(id: params[:comment_id])
      comment.update(
          name: params[:name],
          message: params[:message]
      )
      @response['comment'] = comment
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_comment
    @response = {}

    if params[:comment_id].present?
      comment = Comment.find_by(id: params[:comment_id])
      if comment
        comment.destroy
        @response['comment_id'] = params[:comment_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def change_request_page_status
    @response = {}

    if params[:id].present?
      request = RequestPage.find_by(id: params[:id])
      request.update(status: 1)
      @response['success'] = true
    end

    @response['params'] = params

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_page_request
    @response = {}

    if params[:id].present?
      request = RequestPage.find_by(id: params[:id])
      if request
        request.destroy
        @response['success'] = true
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

end
