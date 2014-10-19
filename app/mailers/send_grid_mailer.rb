class SendGridMailer < ActionMailer::Base
  default from: "meetingz.herokuapp.com"

  def send_summary_emails
    @msg = 'hi'
    mail( :to => ['isaacnoda@gmail.com', 'nodaisaac@gmail.com'],
    :subject => 'Meeting summary' )
  end  
end