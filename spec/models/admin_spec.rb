require 'spec_helper'
 
describe User do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user) }
 
  it "sends an email" do
    expect { UserMailer.change_status(user,"approved").deliver }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end