require 'spec_helper'

describe User do

  before do
    @user = User.new(email: "user@example.com",  password: "foobarer", password_confirmation: "foobarer" )
  end

  after(:all)  { User.delete_all }

  subject { @user }
  it { should respond_to(:ratings) }
  it { should respond_to(:hotels) }
end