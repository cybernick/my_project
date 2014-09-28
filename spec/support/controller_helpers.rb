module ControllerHelpers
  def guest_sign_in(resource_or_scope = :user, options = {})
    allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
    allow(controller).to receive(:current_user).and_return(nil)
  end
end

  RSpec.configure do |config|
    config.include Devise::TestHelpers, :type => :controller
    config.include ControllerHelpers, :type => :controller
  end  
  