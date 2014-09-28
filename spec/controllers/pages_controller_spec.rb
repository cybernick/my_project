require 'spec_helper'

describe PagesController do 
	describe 'GET #home' do
		it "populates an array of hotels ordered by rating" do
			five_star_hotel = create(:hotel, rating: 5)
			three_star_hotel = create(:hotel, rating: 3)
			one_star_hotel = create(:hotel, rating: 1)
			get :home
			expect(assigns(:hotels)).to match_array([five_star_hotel,three_star_hotel,one_star_hotel])
		end

		it "populates an array of hotels with approved status " do
			approved_hotel = create(:hotel, status:"approved")
			rejected_hotel = create(:hotel, status:"rejected")
			pending_star_hotel = create(:hotel, status:"pending")
			get :home
			expect(assigns(:hotels)).to match_array([approved_hotel])
		end

		it "renders the :home view" do
			get :home
			expect(response).to render_template :home
		end
	end 

	describe 'GET #help' do
		it "renders the :help view" do
			get :help
			expect(response).to render_template :help
		end
	end

	describe 'GET #contact' do
		it "renders the :contact view" do
			get :contact
			expect(response).to render_template :contact
		end
	end 

	describe 'GET #about' do
		it "renders the :about view" do
			get :about
			expect(response).to render_template :about
		end
	end  	
end