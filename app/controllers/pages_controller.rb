<<<<<<< HEAD
class PagesController < InheritedResources::Base
=======
class PagesController < ApplicationController
>>>>>>> c24d4d89f8788491636ad4f6b7976d5db75437f8
  before_filter :authenticate_user!, except: [:home, :contact, :about, :list, :help]	
  def home
    @hotels = Hotel.status("approved").order("rating DESC").limit(5)
    @hotels.each {|hotel| hotel.average_rating}
  end
<<<<<<< HEAD
=======

  def help
  end

  def contact
  end

  def about
  end

>>>>>>> c24d4d89f8788491636ad4f6b7976d5db75437f8
end
