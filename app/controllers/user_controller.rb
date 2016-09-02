class UserController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @users = User.all
  end

  def get_user_bookmarks
    @response = {}

    @response['bookmarks'] = Page.joins(:bookmarks).where('bookmarks.user_id' => params[:user_id].to_i)

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

end
