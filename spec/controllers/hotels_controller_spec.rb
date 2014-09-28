require 'spec_helper'

describe HotelsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:wrong_user) { FactoryGirl.create(:user) }

  let(:hotel) { FactoryGirl.create(:hotel, user: user) }
  let(:wrong_hotel) { FactoryGirl.create(:hotel, user: wrong_user) }

  shared_examples("public access to hotels") do
    describe 'GET #index' do
      it "populates an array of all approved hotels" do
        first_hotel = create(:hotel, title: 'First hotel', status:'approved' )
        second_hotel = create(:hotel, title: 'Second hotel', status:'approved' )
        third_hotel = create(:hotel, title: 'Third hotel', status:'rejected' )
        fourth_hotel = create(:hotel, title: 'Fourth hotel', status:'pending' )
        get :index
        expect(assigns(:hotels)).to match_array([first_hotel,second_hotel])
      end

      it "do not have rigths to watch rejected hotels" do
        third_hotel = create(:hotel, title: 'Third hotel', status:'rejected' )
        get :index, :sort => "rejected"
        expect(assigns(:hotels)).not_to match_array([third_hotel])
      end

      it "do not have rigths to watch pending hotels" do
        fourth_hotel = create(:hotel, title: 'Fourth hotel', status:'pending' )
        get :index, :status => "pending"
        expect(assigns(:hotels)).not_to match_array([fourth_hotel])
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end
      
    describe 'GET #show' do
      before :each do
        @hotel = create(:hotel)
        get :show, id: @hotel
      end

      it "assigns the requested hotel to @hotels" do
        expect(assigns(:hotel)).to eq @hotel
      end

      it "renders the :show template" do
        expect(response).to render_template :show
      end
    end
  end

  shared_examples("full access to hotels") do
    describe 'GET #new' do
      before :each do
        get :new
      end

      it "assigns a new Hotel to @hotel" do
        expect(assigns(:hotel)).to be_a_new(Hotel)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        before :each do
          post :create, hotel: attributes_for(:hotel)
        end

        it "saves the new hotel in the database" do
           expect(Hotel.exists?(assigns[:hotel])).to be_true
        end

        it "redirects to hotels#index" do
          expect(response).to redirect_to hotels_path
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, hotel: attributes_for(:invalid_hotel)
        end

        it "does not save the new hotel in the database " do
          expect(Hotel.exists?(assigns[:hotel])).to be_false
        end

        it "re-renders the :new template" do
          expect(response).to render_template :new
        end
      end
    end

    describe 'DELETE #destroy own hotel' do
      before :each do
        allow(hotel).to receive(:destroy).and_return(true)
        delete :destroy, id: hotel
      end

      it "deletes hotel from the database" do
        expect(Hotel.exists?(hotel)).to be_false
      end

      it "redirects to hotels#index" do
        expect(response).to redirect_to hotels_path
      end
    end

    describe 'DELETE #destroy not own hotel' do
      before :each do
        allow(wrong_hotel).to receive(:destroy).and_return(true)
        delete :destroy, id: wrong_hotel
      end

      it "deletes hotel from the database" do
        expect(Hotel.exists?(wrong_hotel)).to be_true
      end

      it "redirects to hotels#index" do
        expect(response).to redirect_to hotels_path
      end
    end
  end

  shared_examples("admin access to hotels") do
    describe 'PATCH #update' do
      context "valid attributes" do
        before :each do
          @hoteltest = create(:hotel_new,status:"pending")
        end

        it "located the requested @hotel" do
          patch :update, id: @hoteltest.id, hotel: attributes_for(:hotel_new, id:@hoteltest.id)
          expect(assigns(:hotel)).to eq(@hoteltest)        
        end

        it "changes @hotel's attributes" do
          patch :update, id: @hoteltest.id, hotel: attributes_for(:hotel_new, id:@hoteltest.id ,status:"approved")
          @hoteltest.reload
          expect(@hoteltest.status).to eq("approved")
        end

        it "redirects to the list of hotels" do
          patch :update, id: @hoteltest.id, hotel: attributes_for(:hotel_new, id:@hoteltest.id)
          expect(response).to redirect_to hotels_path
        end
      end

      context "invalid attributes" do
        before :each do
          @hoteltest = create(:hotel_new,status:"rejected")
        end

        it "located the requested @hotel" do
          patch :update, id: @hoteltest.id, hotel: attributes_for(:hotel_new, id:@hoteltest.id)
          expect(assigns(:hotel)).to eq(@hoteltest)        
        end

        it "changes @hotel's attributes" do
          patch :update, id: @hoteltest.id, hotel: attributes_for(:hotel_new, id:@hoteltest.id ,status:"approved")
          @hoteltest.reload
          expect(@hoteltest.status).to eq("rejected")
        end

        it "redirects to the list of hotels" do
          patch :update, id: @hoteltest.id, hotel: attributes_for(:hotel_new, id:@hoteltest.id)
          expect(response).to redirect_to hotels_path
        end
      end
    end
    describe 'GET #index' do
      it "populates an array of approve hotels using filter" do
        first_hotel = create(:hotel, title: 'First hotel', status:'approved' )
        second_hotel = create(:hotel, title: 'Second hotel', status:'approved' )
        get :index, :status => "approved"
        expect(assigns(:hotels)).to match_array([first_hotel,second_hotel])
      end

      it "populates an array of rejected hotels using filter" do
        third_hotel = create(:hotel, title: 'Third hotel', status:'rejected' )
        get :index, :status => "rejected"
        expect(assigns(:hotels)).to match_array([third_hotel])
      end

      it "populates an array of pending hotels as standart" do
        fourth_hotel = create(:hotel, title: 'Fourth hotel', status:'pending' )
        get :index
        expect(assigns(:hotels)).to match_array([fourth_hotel])
      end

      it "populates an array of pending hotels using filter" do
        fourth_hotel = create(:hotel, title: 'Fourth hotel', status:'pending' )
        get :index, :status => "pending"
        expect(assigns(:hotels)).to match_array([fourth_hotel])
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  shared_examples("without users access to hotels") do
    describe 'GET #new' do
      it "requires login" do
        get :new
        expect(response).to require_login
      end
    end

    describe 'POST #create' do
      it "requires login" do 
        post :create, hotel: attributes_for(:hotel)
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      it "requires login" do
        delete :destroy, id: hotel
        expect(response).to require_login
      end
    end
  end

  describe "user access to hotels" do
     before(:each) do
      sign_in user
    end
    
    it_behaves_like "public access to hotels"
    it_behaves_like "full access to hotels"
  end

  describe "guest access to hotels" do
    login_guest
    
    it_behaves_like "public access to hotels"
    it_behaves_like "without users access to hotels"
  end

  describe "admin access to hotels" do
    login_admin
    
    it "should have a current_admin" do
      expect(subject.current_admin).not_to eq nil
    end
    it_behaves_like "without users access to hotels"
    it_behaves_like "admin access to hotels"
  end
end