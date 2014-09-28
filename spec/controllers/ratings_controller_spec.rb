require 'spec_helper'
describe RatingsController do
	let(:user) { FactoryGirl.create(:user) }
  let(:wrong_user) { FactoryGirl.create(:user) }

  let(:hotel) { FactoryGirl.create(:hotel, user: user) }
  let(:wrong_hotel) { FactoryGirl.create(:hotel, user: wrong_user) }
  
  shared_examples("access for rating") do
		describe 'POST #create rating for not your own hotel' do
	 		before { post :create, rating: attributes_for(:rating), hotel_id: wrong_hotel.id }
				
			it "saves the new rating in the database" do
				expect(Rating.exists?(assigns[:rating])).to be_true
			end

			it "redirects to hotels#show" do
				expect(response).to redirect_to hotel_path(wrong_hotel)
			end
		end

		describe 'POST #create rating for your own hotel' do
	 		before { post :create, rating: attributes_for(:rating), hotel_id: hotel.id }
				
			it "saves the new rating in the database" do
				expect(Rating.exists?(assigns[:rating])).to be_false
			end

			it "redirects to hotels#show" do
				expect(response).to redirect_to hotel_path(hotel)
			end
		end

		describe 'PATCH #update' do
			before :each do
				@rating = create(:rating, user: user, hotel: wrong_hotel)
			end

			it "located the requested @rating" do
				patch :update,id: @rating, rating: attributes_for(:rating), hotel_id: wrong_hotel.id
				expect(assigns(:rating)).to eq(@rating)
			end

			it "changes @rating's attributes" do
				patch :update, id: @rating, rating: attributes_for(:rating, value: 1, comment:"Bad"), hotel_id: wrong_hotel.id
				@rating.reload
				expect(@rating.value).to eq(1)
				expect(@rating.comment).to eq("Bad")
			end

			it "redirects to the update contact" do
				patch :update, id: @rating, rating: attributes_for(:rating), hotel_id: wrong_hotel.id
				expect(response).to redirect_to hotel_path(wrong_hotel)
			end
		end
	end

	shared_examples("do not have access for rating") do
		describe 'POST #create' do
      it "requires login" do 
        post :create, rating: attributes_for(:rating)
        expect(response).to require_login
      end
    end

    describe 'PATCH #update' do
    	before :each do
				@rating = create(:rating, user: user, hotel: wrong_hotel)
			end
      it "requires login" do 
        patch :update,id: @rating, rating: attributes_for(:rating), hotel_id: wrong_hotel.id
        expect(response).to require_login
      end
    end
	end

	describe "user access to hotels" do
  	before(:each) do
      sign_in user
    end

   	it_behaves_like "access for rating"
  end

  describe "guest access to hotels" do
  	login_guest

	it_behaves_like "do not have access for rating"   
  end

  describe "admin access to hotels" do
  	login_admin

	it_behaves_like "do not have access for rating"   
  end
end