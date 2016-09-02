class LoginController < ApplicationController

  def create_default
    admin = Admin.find_by(id: 1)
    if !admin
      admin = Admin.new
      admin.email = 'admin'
      admin.password = 'belainfo31'
      admin.save!
    end

    redirect_to '/admin'
  end

  def get_article
    @response = {}

    @response = Article.find_by(:id => params[:article_id])

    respond_to do |format|
      format.json { render :json => @response }
    end
  end
end