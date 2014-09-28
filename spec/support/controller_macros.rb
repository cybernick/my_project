module ControllerMacros
  def login_admin
    before(:each) do
      sign_in FactoryGirl.create(:admin) # Using factory girl as an example
    end
  end

  def login_user
    before(:each) do
      sign_in FactoryGirl.create(:user) 
    end
  end

  def login_guest
    before(:each) do
      guest_sign_in nil
    end
  end
end