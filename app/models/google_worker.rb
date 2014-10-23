class GoogleWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    user.contacts_jid = jid
    user.fetch_contacts
  end  
end