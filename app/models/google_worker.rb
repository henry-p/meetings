class GoogleWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find_by_id(user_id)

    if user
      user.fetch_contacts
      user.update(contacts_jid: '') 
    end
  end  
end