require 'spec_helper'

describe Admin::UsersController do
  let(:user) { FactoryGirl.create(:user) }

  shared_examples("full access to users") do
    describe 'GET #index' do
      it "populates an array of all users" do
        first_user = create(:user)
        second_user = create(:user)
        get :index
        expect(assigns(:users)).to match_array([first_user,second_user])
      end

      it "populates an array of all users sorted by name" do
        first_user = create(:user, username: "aa")
        second_user = create(:user, username: "bb")
        get :index , :sort => "username" , :direction => "desc"
        expect(assigns(:users)).to match_array([second_user,first_user])
      end

      it "populates an array of all users sorted by email" do
        first_user = create(:user, email: "aa@aa.com")
        second_user = create(:user, email: "bb@bb.com")
        get :index , :sort => "email" , :direction => "desc"
        expect(assigns(:users)).to match_array([second_user,first_user])
      end

      it "populates an array of all users sorted by number of hotel" do
        first_user = create(:user, number_of_hotel: 5)
        second_user = create(:user, number_of_hotel: 3)
        get :index , :sort => "number_of_hotel" , :direction => "desc"
        expect(assigns(:users)).to match_array([second_user,first_user])
      end

      it "populates an array of all users sorted by number of comment" do
        first_user = create(:user, number_of_comment: 5)
        second_user = create(:user, number_of_comment: 3)
        get :index , :sort => "number_of_comment" , :direction => "desc"
        expect(assigns(:users)).to match_array([second_user,first_user])
      end

      it "populates an array of all users with filters" do
        first_user = create(:user, username:"Vasya",email:"qwe@qwe.com")
        second_user = create(:user, username:"Vasya",email:"aaa@aaa.com")
        get :index , :search_username => "Vasya" , :search_email => "aaa@aaa.com"
        expect(assigns(:users)).to match_array([second_user])
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      before :each do
        @user = create(:user)
        get :show, id: @user
      end

      it "assigns the requested user to @users" do
        expect(assigns(:user)).to eq @user
      end

      it "renders the :show template" do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      before :each do
        get :new
      end

      it "assigns a new User to @user" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        before :each do
          post :create, user: attributes_for(:user)
        end

        it "saves the new user in the database" do
           expect(User.exists?(assigns[:user])).to be_true
        end

        it "redirects to users#index" do
          expect(response).to redirect_to admin_users_path
        end
      end

      context "with invalid attributes" do
        before :each do
          post :create, user: attributes_for(:invalid_user)
        end

        it "does not save the new user in the database " do
          expect(User.exists?(assigns[:user])).to be_false
        end

        it "re-renders the :new template" do
          expect(response).to render_template :new
        end
      end
    end

    describe "PATCH #update" do
      context "valid attributes" do
        it "located the requested user" do
          patch :update, id: user, user: attributes_for(:user)
          expect(assigns(:user)).to eq(user)
        end

        it "changes user's attributes" do
          patch :update, id: user, user: attributes_for(:user,username:"Vasya")
          user.reload
          expect(user.username).to eq("Vasya")
        end

        it "redirects to the list of users" do
          patch :update, id: user, user: attributes_for(:user)
          expect(response).to redirect_to admin_users_path
        end
      end
    end

    describe 'DELETE #destroy user' do
      before :each do
        allow(user).to receive(:destroy).and_return(true)
        delete :destroy, id: user
      end

      it "deletes user from the database" do
        expect(User.exists?(user)).to be_false
      end

      it "redirects to users#index" do
        expect(response).to redirect_to admin_users_path
      end
    end
  end

  shared_examples("without admin access to users") do
    describe 'GET #index' do
      it "requires login" do
        get :index
        expect(response).to require_admin_login
      end
    end

    describe 'GET #show' do
      it "requires login" do
        get :show, id: user
        expect(response).to require_admin_login
      end
    end

    describe 'GET #new' do
      it "requires login" do
        get :new
        expect(response).to require_admin_login
      end
    end

    describe 'POST #create' do
      it "requires login" do 
        post :create, user: attributes_for(:user)
        expect(response).to require_admin_login
      end
    end

    describe 'POST #update' do
      it "requires login" do 
        post :update,id:user, user: attributes_for(:user)
        expect(response).to require_admin_login
      end
    end

    describe 'DELETE #destroy' do
      it "requires login" do
        delete :destroy, id: user.id
        expect(response).to require_admin_login
      end
    end
  end

  describe "admin access to users" do
    login_admin
    it "should have a current_admin" do
      expect(subject.current_admin).not_to eq nil
    end
    it_behaves_like "full access to users"
  end

  describe "user access to users" do
    login_user
    it "should have a current_user" do
      expect(subject.current_user).not_to eq nil
    end
    it_behaves_like "without admin access to users"
  end

  describe "guest access to users" do
    login_guest
    it "should not have a current_user" do
      expect(subject.current_user).to eq nil
    end
    it_behaves_like "without admin access to users"
  end
end