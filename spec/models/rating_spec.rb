require 'spec_helper'

describe Rating do

  let(:user) { FactoryGirl.create(:user) }
  let(:hotel) { FactoryGirl.create(:hotel, user: user) }
  let(:rating) { user.ratings.create(hotel_id: hotel.id,value:5) }
  
  after(:all)  { User.delete_all }
  after(:all)  { Hotel.delete_all }
  after(:all)  { Rating.delete_all }
  
  
  subject { rating }
  
  it { should be_valid }
 
  describe "rating methods" do
    it { should respond_to(:hotel_id) }
    it { should respond_to(:user_id) }
    it { should respond_to(:value) }
    it { should respond_to(:comment) }
    its(:hotel_id) { should eq hotel.id }
    its(:user_id) { should eq user.id }
  end

  describe "when user id is not present" do
    before { rating.user_id = nil }
    it { should_not be_valid }
  end

  describe "when hotel id is not present" do
    before { rating.hotel_id = nil }
    it { should_not be_valid }
  end

  describe "when value is not present" do
    before { rating.value = nil }
    it { should_not be_valid }
  end
end