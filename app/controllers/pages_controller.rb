class PagesController < InheritedResources::Base

  before_filter :authenticate_user!, except: [:home, :contact, :about, :list, :help, :discipline]	
  def home
    @articles = Article.status("approved").order("rating DESC").limit(5)
    @articles.each {|article| article.average_rating}
  end

  def help
  end

  def contact
  end

  def about
  end

  def discipline
  end

end
