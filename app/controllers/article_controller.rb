class ArticleController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @articles = Article.all
  end

  def get_article
    @response = {}

    @response = Article.find_by(:id => params[:article_id])

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def save_article
    @response = {}

    data = {
        header: params[:header],
        text: params[:text],
        status: params[:status]
    }

    if params[:article_id].present?
      article = Article.find_by(id: params[:article_id])
      article.update(data)
    else
      article = Article.create(data)
      @response['new'] = true
    end

    @response['article'] = article

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

end
