class SendGridWorker
  include Sidekiq::Worker

  def perform(meeting)
    SendGridMailer.send_summary_emails(meeting).deliver
  end
end