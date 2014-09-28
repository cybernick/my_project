require "spec_helper"

describe UserMailer do
  describe 'change_status' do
  	let(:user) { FactoryGirl.create(:user) }
  	let(:mail) { UserMailer.change_status(user,"approved")}

  	it 'renders the subject' do
  		expect(mail.subject).to eql('approved')
  	end

  	it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
 
    it 'renders the sender email' do
      expect(mail.from).to eql(['admin@hotels.org'])
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to match("approved")
    end
  end
end
