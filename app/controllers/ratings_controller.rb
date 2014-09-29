class RatingsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @article = Article.find_by_id(params[:article_id])
    if current_user.id == @article.user_id
      redirect_to article_path(@article), :alert => "You cannot rate and commenting for your own article"
    else
      @rating = Rating.new(params[:rating])
      @rating.article_id = @article.id
      @rating.user_id = current_user.id
      if @rating.save
        respond_to do |format|
          format.html { redirect_to article_path(@article), :notice => "Your rating and comment has been saved" }
          format.js
        end
      end
    end
  end
  
  def update
    @article = Article.find_by_id(params[:article_id])
    if current_user.id == @article.user_id
      redirect_to article_path(@article), :alert => "You cannot rate or comments for your own article"
    else
      @rating = current_user.ratings.find_by_article_id(@article.id.to_s)
      if @rating.update_attributes!(params[:rating])
        respond_to do |format|
        format.html { redirect_to article_path(@article), :notice => "Your rating and comment has been updated" }
        format.js
        end
      end
    end
  end
end