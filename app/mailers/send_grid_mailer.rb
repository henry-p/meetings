class SendGridMailer < ActionMailer::Base
  default from: "meetingz.herokuapp.com"

  def send_summary_emails(meeting)
    @meeting = meeting
    mail( :to => @meeting.email_array_for_mailer,
    :subject => "Meeting summary for #{@meeting.title} (#{Meeting.format_timestamp @meeting.start_time} )")
  end  
end