class SendGridWorker
  include Sidekiq::Worker

  def perform(meeting_id)
    meeting = Meeting.find_by_id(meeting_id)
    SendGridMailer.send_summary_emails(meeting).deliver
  end
end