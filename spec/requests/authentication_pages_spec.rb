require 'spec_helper'

describe "Authentication" do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:hotel) { FactoryGirl.create(:hotel) }

	subject { page }

	describe "signin page for user" do
    before { visit new_user_session_path }

    it { should have_content('Sign in') }
    it { should have_title(full_title('Sign in')) }

    describe "with invalid information" do
    	before { click_button "Sign in" }
    	it { should have_content('alert Invalid email or password. ') }
    end

    describe "with admin information" do
      before do
        fill_in "Email",    with: admin.email.upcase
        fill_in "Password", with: admin.password
        click_button "Sign in"
      end
      it { should have_content('alert Invalid email or password. ') }
    end

    describe "with valid information" do

      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

    	it { should have_title(full_title('Home')) }
      it { should have_link('List',    href: hotels_path) }
   		it { should have_link('Sign out',    href: destroy_user_session_path) }
      it { should_not have_link('Sign in', href: new_user_session_path) }
      it { should have_content('Здравствуйте, '+user.email)}

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "signin page for admin" do
    before { visit new_admin_session_path }

    it { should have_content('Sign in') }
    it { should have_title(full_title('Sign in')) }

    describe "with invalid information" do
      before { click_button "Sign in" }
      it { should have_content('alert Invalid email or password. ') }
    end

    describe "with user information" do
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      it { should have_content('alert Invalid email or password. ') }
    end

    describe "with valid information" do

      before do
        fill_in "Email",    with: admin.email.upcase
        fill_in "Password", with: admin.password
        click_button "Sign in"
      end

      it { should have_title(full_title('Home')) }
      it { should have_link('List',    href: hotels_path) }
      it { should have_link('Sign out(admin)',    href: destroy_admin_session_path) }
      it { should have_link('Users',    href: admin_users_path) }
      it { should_not have_link('Sign in', href: new_user_session_path) }
      it { should have_content('Здравствуйте, '+admin.email)}

      describe "followed by signout" do
        before { click_link "Sign out(admin)" }
        it { should have_link('Sign in') }
      end
    end
  end
  
  describe "authorization" do
    describe "for non-signed-in users" do
      describe "visiting the add new hotel page" do
        before { visit hotels_new_path }
        it { should have_title(full_title('Sign in')) }
      end
    end
  end
end