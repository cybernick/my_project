class PagesController < InheritedResources::Base

  before_filter :authenticate_user!, except: [:home, :contact, :about, :list, :help]	
  def home
    @hotels = Hotel.status("approved").order("rating DESC").limit(5)
    @hotels.each {|hotel| hotel.average_rating}
  end

  def help
  end

  def contact
  end

  def about
  end

end
