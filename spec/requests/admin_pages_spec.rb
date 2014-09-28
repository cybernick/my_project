require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Admin pages" do

  subject { page }
  before(:all){User.delete_all}
  let(:admin) { FactoryGirl.create(:admin) }
  before { login_as(admin, :scope => :admin, :run_callbacks => false) }
  
  describe "index" do

    before do
      10.times { FactoryGirl.create(:user) }
      visit admin_users_path
    end

    it { should have_title(full_title('List of Users')) }
    it { should have_selector('h1', text: "Users") }
    it { should have_selector('div.pagination') }

    it "should list each hotel" do
      User.paginate(page: 2).each do |user|
        expect(page).to have_selector('td', text: user.id)
        expect(page).to have_selector('td', text: user.number_of_hotel)
        expect(page).to have_selector('td', text: user.number_of_comment)
        expect(page).to have_selector('td', text: user.created_at)
        expect(page).to have_link(user.email, href: admin_user_path(user)) 
      end
    end

    describe "should be able to filtering Users" do
       before do
        @user=FactoryGirl.create(:user,username:"Vasya", email:"vasya@gmail.com")
        @user_filtered=FactoryGirl.create(:user,username:"Petya", email:"petya@gmail.com")
        fill_in 'search_username',            with: "Vasya"
        click_button('Search user')
        fill_in 'search_email', with: "vasya@gmail.com"
        click_button('Search email')
      end

      it {should have_selector('td', text: "Vasya") }
      it {should have_link(@user.email, href: admin_user_path(@user)) }
      it {should_not have_selector('td', text: "Petya") }
      it {should_not have_link(@user_filtered.email, href: admin_user_path(@user_filtered)) }
    end


    it "should be able to delete user" do
      expect do
        click_link 'Destroy', match: :first
      end.to change(User, :count).by(-1) 
    end

    describe "should have Show button" do
      it { should have_link('Show', href:admin_user_path(User.first)) }
    end

    describe "should have Edit button" do
      it { should have_link('Edit', href:edit_admin_user_path(User.first)) }
    end

    describe "should have New button" do
      it { should have_link('New', href:new_admin_user_path) }
    end
  end

  describe "show details information page" do
    before do
      @user=FactoryGirl.create(:user)
      visit admin_user_path(@user)
    end

    it { should have_title(full_title(@user.username)) }
    it { should have_selector('p', text: @user.username)}
    it { should have_selector('p', text: @user.email)}
  end

  describe "new user page" do
    before do
      visit new_admin_user_path
    end

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button('Save') }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in 'Username',            with: "Vasya"
        fill_in 'Email', with: "vasya@gmail.com"
        fill_in 'password', with: "password"
        fill_in 'user_password_confirmation', with: "password"
      end

      it "should create a hotel" do
        expect { click_button('Save') }.to change(User, :count).by(1)
      end
    end
  end

  describe "edit user page" do
    before do
      @user=FactoryGirl.create(:user)
      visit edit_admin_user_path(@user)
    end

    describe "with invalid information" do
      before do
        fill_in 'Username',            with: ""
        fill_in 'Email', with: ""
        fill_in 'password', with: ""
        fill_in 'user_password_confirmation', with: ""
        click_button('Save')
        visit admin_user_path(@user)
      end
    
      it { should have_title(full_title(@user.username)) }
      it { should have_selector('p', text: @user.username)}
      it { should have_selector('p', text: @user.email)}
    
    end

    describe "with valid information" do
      before do
        fill_in 'Username',            with: "Vasyan"
        fill_in 'Email', with: "vasyan@gmail.com"
        fill_in 'password', with: "password"
        fill_in 'user_password_confirmation', with: "password"
        click_button('Save')
        visit admin_user_path(@user)
      end

      it { should have_title(full_title("Vasyan")) }
      it { should have_selector('p', text: "Vasyan")}
      it { should have_selector('p', text: "vasyan@gmail.com")}
    end
  end
end