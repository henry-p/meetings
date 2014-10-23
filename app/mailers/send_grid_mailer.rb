class SendGridMailer < ActionMailer::Base
  default from: "meetingz.herokuapp.com"

  def send_summary_emails(meeting)
    @meeting = meeting
    mail( :to => @meeting.email_array_for_mailer,
    :subject => "Meeting summary for #{@meeting.title} (#{Meeting.show_start_datetime(@meeting.start_time, @meeting.time_zone)} )")
  end  
end