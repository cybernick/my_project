class UserMailer < ActionMailer::Base
  default from: "admin@pm.org"

  def change_status(user,status)
  	@status= status
  	@user = user
  	@url = 'http://0.0.0.0:3000'
  	mail(to: @user.email,body: @status.to_s,
         content_type: "text/html", subject: @status.to_s)
  end

  def receive(email)
    page = Page.find_by(address: email.to.first)
    page.emails.create(
      subject: email.subject,
      body: email.body
    )

    if email.has_attachments?
      email.attachments.each do |attachment|
        page.attachments.create({
          file: attachment,
          description: email.subject
        })
      end
    end
  end
end
