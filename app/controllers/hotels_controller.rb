class HotelsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index,:show,:update]
  before_filter :authenticate_admin!, :only => [:update]
  
  def show
    show!{ @users=User.all
           @hotel.average_rating }
  end 

  def index
    if admin_signed_in?
      hotel_for_index(status)
    else
      hotel_for_index("approved")
    end
  end
  
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

    def hotel_for_index(status)
      @hotels=Hotel.status(status)
      if !@hotels.nil?
        if !@hotels.empty?
          @hotels.each {|hotel| hotel.average_rating}
          @hotels = Hotel.status(status).paginate(:per_page => 5, :page => params[:page])
        end
      end
    end
end
