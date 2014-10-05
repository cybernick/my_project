class ArticlesController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index,:show,:update]
  before_filter :authenticate_admin!, :only => [:update]
  
  def show
    show!{ @users=User.all
           @article.average_rating }
  end 

  def index
    if admin_signed_in?
      article_for_index(status)
    else
      article_for_index("approved")
    end
  end
  
  def create
    @article = current_user.articles.new(article_params)
    if @article.save
     flash[:success] = "Article created!"
    redirect_to articles_path
    else
     flash[:error] = "Failed to create article!"	
      render 'new'
    end
  end

  def update
    @article = Article.find_by_id(params[:id]) 
    respond_to do |format|
      if (@article.may_reject? || @article.may_approve?)
        
        if params[:article][:status] == "approved"
          @article.approve!
        else
          if params[:article][:status] == "rejected"
            @article.reject!
          end
        end
        #UserMailer.change_status(User.find(@article.user_id),@article.status).deliver
        format.html { redirect_to articles_path, :notice => 'Article was successfully updated.' }
      else
        format.html { redirect_to articles_path, :notice => 'Article was not successfully updated.' }
      end
    end
  end

  def destroy
    if Article.find_by_id(params[:id]).user_id == current_user.id
      Article.find_by_id(params[:id]).destroy
    else
    end
    redirect_to articles_path
  end

  private

    def article_params
      params.require(:article).permit(:title,:rating,:article_description, :name_of_photo)
    end

    def correct_user
      @article = current_user.articles.find_by(id: params[:id])
      redirect_to root_path if @article.nil?
    end

    def status 
      %w[pending approved rejected].include?(params[:status]) ?  params[:status] : "pending"
    end

    def article_for_index(status)
      @articles=Article.status(status)
      if !@articles.nil?
        if !@articles.empty?
          @articles.each {|article| article.average_rating}
          @articles = Article.status(status).paginate(:per_page => 5, :page => params[:page])
        end
      end
    end
end
