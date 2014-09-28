require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit new_user_registration_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }

    let(:submit) { "Sign up" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
       	before { click_button submit }
        it { should have_title(full_title('Sign up')) }
        it { should have_content('Email can\'t be blank') }
        it { should have_content('Password can\'t be blank') }
    	end

    	describe "Password confirmation doesn'n match" do
      	before do
        	fill_in "Email",        with: "example@example.com"
        	fill_in "Password",     with: "foobarer"
        	fill_in "Password confirmation", with: "foobarer123"
        	click_button submit
     	 	end
     	 	it { should have_content('Password confirmation doesn\'t match Password') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Email",        with: "example@example.com"
        fill_in "Password",     with: "foobarer"
        fill_in "Password confirmation", with: "foobarer"
      end

      it "should create a user" do
      expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'example@example.com') }
        after(:all)  { User.delete_all }
        it { should have_link('Sign out') }
        it { should have_content('Здравствуйте, '+user.email)}
      end
 	  end
 	end
end
