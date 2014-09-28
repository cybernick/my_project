require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Hotel pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:wrong_user) { FactoryGirl.create(:user) } 

  
  let(:hotel) { FactoryGirl.create(:hotel,user: user) }
  let(:wrong_hotel) { FactoryGirl.create(:hotel,user: wrong_user) } 

  describe "index" do

    before do
      login_as(user, :scope => :user, :run_callbacks => false)
      10.times { FactoryGirl.create(:hotel,user: user) }
      visit hotels_path
    end

    after do
      logout(:user)
    end

    it { should have_title(full_title('List of Hotels')) }
    it { should have_selector('h1', text: "List of Hotel") }
    it { should have_selector('div.pagination') }

    it "should list each hotel" do
      Hotel.paginate(page: 2).each do |hotel|
        expect(page).to have_selector('li', text: hotel.title)
        expect(page).to have_selector('li', text: hotel.status)
        expect(page).to have_selector('li', text: hotel.rating)
        expect(page).to have_selector('li', text: hotel.room_description)
        expect(page).to have_link('details', href: hotel_path(hotel)) 
      end
    end

    it "should be able to delete own Hotel" do
      expect do
        click_link 'delete', match: :first
      end.to change(Hotel, :count).by(-1) 
    end

    describe "should not be able to delete other users Hotels" do
      it { should_not have_link('delete', href:hotel_path(wrong_hotel)) }
    end

    describe "should have Add Hotel button" do
      it { should have_link('Add Hotel', href:new_hotel_path) }
    end
  end

  describe "show details information page" do
    before do
      login_as(user, :scope => :user, :run_callbacks => false)
      visit hotel_path(hotel)
    end

    after do
      logout(:user)
    end


    it { should have_title(full_title(hotel.title)) }
    it { should have_selector('li', text: hotel.price_for_room)}
    it { should have_selector('li', text: hotel.room_description)}
    it { should have_selector('li', text: hotel.country)}
    it { should have_selector('li', text: hotel.state)}
    it { should have_selector('li', text: hotel.city)}
    it { should have_selector('li', text: hotel.street)}
    it { should have_selector('li', text: hotel.rating )}

    describe "rate your own hotel" do
      it "should not increment the Rating" do
        expect do
          choose('rating_value_5'        )
          click_button('submit')
        end.not_to change(Rating, :count)
      end
    end  

    describe "rate not your own hotel" do
      before do
        visit hotel_path(wrong_hotel)
      end

      it "should add your rating and comment" do
        expect do
          choose('rating_value_5'        )
          click_button('submit')
        end.to change(Rating, :count).by(1)
        should have_button('submit!')
        fill_in 'rating_comment',       with: "comment"
        click_button('submit!')
        wrong_hotel.ratings.find_by_user_id(user).comment.should eq "comment"
        should have_selector('h1', text: "Comments")
        should have_selector('li', text:user.email + ": " + wrong_hotel.ratings.find_by_user_id(user).comment)
      end  
    end
  end

  describe "new hotel page" do
    before do
      login_as(user, :scope => :user, :run_callbacks => false)
      visit new_hotel_path
    end

    after do
      logout(:user)
    end

    describe "with invalid information" do
      it "should not create a hotel" do
        expect { click_button('Create Hotel') }.not_to change(Hotel, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in 'hotel_title',            with: "Example Hotel"
        fill_in 'hotel_room_description', with: "Room description"
        uncheck('hotel_breakfast'        )
        fill_in 'hotel_price_for_room',   with: 60.0
        select 'Albania', :from => 'hotel_country'
        fill_in 'hotel_state',            with: "California"
        fill_in 'hotel_city',             with: "LA"
        fill_in 'hotel_street',           with: "City"
      end

      it "should create a hotel" do
        expect { click_button('Create Hotel') }.to change(Hotel, :count).by(1)
      end
    end
  end

  describe "hotels page for admin" do
    before do
      login_as(admin, :scope => :admin, :run_callbacks => false)
      10.times { FactoryGirl.create(:hotel,user:user,status:"pending") }
      10.times { FactoryGirl.create(:hotel,user:user,status:"approved") }
      10.times { FactoryGirl.create(:hotel,user:user,status:"rejected") }
      visit hotels_path
    end
    it { should have_title(full_title('List of Hotels')) }
    it { should have_selector('h1', text: "List of Hotels") }
    it { should have_selector('div.pagination') }
    it { should have_link('Pending') }
    it { should have_link('Approved') }
    it { should have_link('Rejected') }
    
    describe "pending page" do
      before do
        click_link('Pending')
      end
      it "should list of pendings hotel" do
        Hotel.paginate(page: 2).each do |hotel|
          expect(page).to have_selector('li', text: hotel.title)
          expect(page).to have_selector('li', text: "pending")
        end
      end
    end

    describe "approved page" do
      before do
        click_link('Pending')
      end
      it "should list of pendings hotel" do
        Hotel.paginate(page: 2).each do |hotel|
          expect(page).to have_selector('li', text: hotel.title)
          expect(page).to have_selector('li', text: "approved")
        end
      end
    end

    describe "rejected page" do
      before do
        click_link('Pending')
      end
      it "should list of pendings hotel" do
        Hotel.paginate(page: 2).each do |hotel|
          expect(page).to have_selector('li', text: hotel.title)
          expect(page).to have_selector('li', text: "rejected")
        end
      end
    end

    describe "show details information page" do
      before do
        @hotel = FactoryGirl.create(:hotel,status:"pending",title:"Hotel for status")
        visit hotel_path(@hotel)
      end

      describe "change hotel status" do
        before do
          select 'Approved' , :from => 'hotel_status'
          click_button('submit')
          visit hotels_path
          click_link('Approved')
        end
        it "should have approved hotel" do
          Hotel.paginate(page: 2) do
            expect(page).to have_selector('li', text: @hotel.title)
            expect(page).to have_selector('li', text: "approved")
          end
        end
      end  
    end
  end
end