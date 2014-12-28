class ArticlesController < ApplicationController
  before_filter :require_login, except: [:index, :show]

  include ArticlesHelper
  def index
    if params[:month]
      @articles = Article.find_by_month(params[:month])
    elsif params[:popularity]
      @articles = Article.most_popular.take(3)
    else
      @articles = Article.all
    end
    
    # respond_to do |format|
    #   format.html { render }
    #   format.rss { render :layout => false }
    # end
  end

  def show
    @article = Article.find(params[:id])
    @comment = Comment.new
    @comment.article_id = @article.id
    @article.view
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.save
    flash.notice = "Article '#{@article.title}' was created!"
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash.notice = "Article '#{@article.title}' was deleted!"
    redirect_to articles_path
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)
    flash.notice = "Article '#{@article.title}' was updated!"
    redirect_to article_path(@article)
  end
end
