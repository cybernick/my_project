class RatingsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @hotel = Hotel.find_by_id(params[:hotel_id])
    if current_user.id == @hotel.user_id
      redirect_to hotel_path(@hotel), :alert => "You cannot rate and commenting for your own hotel"
    else
      @rating = Rating.new(params[:rating])
      @rating.hotel_id = @hotel.id
      @rating.user_id = current_user.id
      if @rating.save
        respond_to do |format|
          format.html { redirect_to hotel_path(@hotel), :notice => "Your rating and comment has been saved" }
          format.js
        end
      end
    end
  end
  
  def update
    @hotel = Hotel.find_by_id(params[:hotel_id])
    if current_user.id == @hotel.user_id
      redirect_to hotel_path(@hotel), :alert => "You cannot rate or comments for your own hotel"
    else
      @rating = current_user.ratings.find_by_hotel_id(@hotel.id.to_s)
      if @rating.update_attributes!(params[:rating])
        respond_to do |format|
        format.html { redirect_to hotel_path(@hotel), :notice => "Your rating and comment has been updated" }
        format.js
        end
      end
    end
  end
end