<<<<<<< HEAD
class HotelsController < InheritedResources::Base
=======
class HotelsController < ApplicationController
>>>>>>> c24d4d89f8788491636ad4f6b7976d5db75437f8
  before_filter :authenticate_user!, :except => [:index,:show,:update]
  before_filter :authenticate_admin!, :only => [:update]
  
  def show
<<<<<<< HEAD
    show!{ @users=User.all
           @hotel.average_rating }
=======
  @users=User.all
	@hotel=Hotel.find_by_id(params[:id])
  @hotel.average_rating
>>>>>>> c24d4d89f8788491636ad4f6b7976d5db75437f8
  end 

  def index
    if admin_signed_in?
<<<<<<< HEAD
      hotel_for_index(status)
    else
      hotel_for_index("approved")
    end
  end
=======
      @hotels=Hotel.status(status)
      if !@hotels.empty?
        @hotels.each {|hotel| hotel.average_rating}
        @hotels = Hotel.status(status).paginate(:per_page => 5, :page => params[:page])
      end
    else
      @hotels=Hotel.status("approved")
      if !@hotels.nil?
        if !@hotels.empty?
          @hotels.each {|hotel| hotel.average_rating}
          @hotels = Hotel.status("approved").paginate(:per_page => 5, :page => params[:page])
        end
      end
    end
  end

  def new
  	@hotel=current_user.hotels.new
  end
>>>>>>> c24d4d89f8788491636ad4f6b7976d5db75437f8
  
  def create
    @hotel = current_user.hotels.new(hotel_params)
    if @hotel.save
     flash[:success] = "Hotel created!"
    redirect_to hotels_path
    else
     flash[:error] = "Failed to create hotel!"	
      render 'new'
    end
  end

  def update
    @hotel = Hotel.find_by_id(params[:id]) 
    respond_to do |format|
<<<<<<< HEAD
      if (@hotel.may_reject? || @hotel.may_approve?)
        
        if params[:hotel][:status] == "approved"
          @hotel.approve!
        else
          if params[:hotel][:status] == "rejected"
            @hotel.reject!
          end
        end
        UserMailer.change_status(User.find(@hotel.user_id),@hotel.status).deliver
        format.html { redirect_to hotels_path, :notice => 'Hotel was successfully updated.' }
      else
        format.html { redirect_to hotels_path, :notice => 'Hotel was not successfully updated.' }
=======
      if (((@hotel.status == "rejected") && (params[:hotel][:status] == "approved")) || ((@hotel.status == "approved") && (params[:hotel][:status] == "rejected")))
        format.html { redirect_to hotels_path, :notice => 'Hotel was not successfully updated.' }
        format.json { head :no_content }
      else
        if @hotel.update_attributes(params[:hotel])
          UserMailer.change_status(User.find(@hotel.user_id),@hotel.status).deliver
          format.html { redirect_to hotels_path, :notice => 'Hotel was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render :action => "show" }
          format.json { render :json => @hotel.errors, :status => :unprocessable_entity }
        end
>>>>>>> c24d4d89f8788491636ad4f6b7976d5db75437f8
      end
    end
  end

  def destroy
    if Hotel.find_by_id(params[:id]).user_id == current_user.id
      Hotel.find_by_id(params[:id]).destroy
    else
    end
    redirect_to hotels_path
  end

  private

    def hotel_params
      params.require(:hotel).permit(:title,:rating,:breakfast,:price_for_room,:country,:state,:city,:street, :room_description, :name_of_photo)
    end

    def correct_user
      @hotel = current_user.hotels.find_by(id: params[:id])
      redirect_to root_path if @hotel.nil?
    end

    def status 
      %w[pending approved rejected].include?(params[:status]) ?  params[:status] : "pending"
    end
<<<<<<< HEAD

    def hotel_for_index(status)
      @hotels=Hotel.status(status)
      if !@hotels.nil?
        if !@hotels.empty?
          @hotels.each {|hotel| hotel.average_rating}
          @hotels = Hotel.status(status).paginate(:per_page => 5, :page => params[:page])
        end
      end
    end
=======
>>>>>>> c24d4d89f8788491636ad4f6b7976d5db75437f8
end
