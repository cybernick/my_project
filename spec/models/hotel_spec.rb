require 'spec_helper'

describe Hotel do

  let(:user) { FactoryGirl.create(:user) }
  
  before do
    @hotel = user.hotels.build(title: "Lorem ipsum",breakfast: true,room_description:"Lorem ipsum",price_for_room: 60.0,
    					country:"USA",state:"California",city:"LA",street:"street")
    @hotel.save
	end
  
  let(:wrong_user) { FactoryGirl.create(:user) }

  after(:all)  { User.delete_all }
  after(:all)  { Hotel.delete_all }


  it "should be nil when there are no reviews" do
    @hotel.average_rating
    @hotel.rating.should eq(0)
  end

  it "should calculate average rating properly" do
    @hotel.ratings.build(value: 1,comment:"super",user_id:wrong_user.id, hotel_id: @hotel.id, user:wrong_user, hotel: @hotel)
    @hotel.ratings.build(value: 2,comment:"super",user_id:wrong_user.id, hotel_id: @hotel.id, user:wrong_user, hotel: @hotel)
    @hotel.ratings.build(value: 2,comment:"super",user_id:wrong_user.id, hotel_id: @hotel.id, user:wrong_user, hotel: @hotel)
    @hotel.average_rating
    @hotel.rating.should be_within(0.001).of(1.67)
  end

  subject { @hotel }

  it { should respond_to(:title) }
  it { should respond_to(:rating) }
  it { should respond_to(:breakfast) }
  it { should respond_to(:room_description) } 
  it { should respond_to(:price_for_room) } 
  it { should respond_to(:user_id) } 
  it { should respond_to(:name_of_photo) } 
  it { should respond_to(:country) }
  it { should respond_to(:state) }
  it { should respond_to(:city) }
  it { should respond_to(:street) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @hotel.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank title" do
    before { @hotel.title = " " }
    it { should_not be_valid }
  end

  describe "with char price_for_room" do
    before { @hotel.price_for_room = "char" }
    it { should_not be_valid }
  end

  describe "with blank  room_description" do
    before { @hotel.room_description = " " }
    it { should_not be_valid }
  end

  describe "with blank country" do
    before { @hotel.country = " " }
    it { should_not be_valid }
  end

  describe "with blank state" do
    before { @hotel.state = " " }
    it { should_not be_valid }
  end

  describe "with blank city" do
    before { @hotel.city = " " }
    it { should_not be_valid }
  end

  describe "with blank street" do
    before { @hotel.street = " " }
    it { should_not be_valid }
  end
end
