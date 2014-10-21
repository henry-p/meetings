class User < ActiveRecord::Base
  include HTTParty
  has_many :responsibilities
  has_many :assigned_actionables, through: :responsibilities, source: :actionable

  has_many :created_actionables, class_name: "Actionable", foreign_key: :creator_id

  has_many :votes, foreign_key: :voter_id
  has_many :voted_agenda_topics, through: :votes, source: :agenda_topic

  has_many :invites, foreign_key: :invitee_id
  has_many :meetings, through: :invites

  has_many :meetings, foreign_key: :creator_id

  has_many :agenda_topics, foreign_key: :creator_id

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def google_api_client
    client = Google::APIClient.new
    client.authorization.access_token = self.token
    client.auto_refresh_token = true
    client
  end

  def calendar_service
    self.google_api_client.discovered_api('calendar', 'v3')
  end

  def delete_event(event_id)
  	self.google_api_client.execute(:api_method => self.calendar_service.events.delete,
                                   :parameters => { 'calendarId' => 'primary', 'eventId' => event_id, 'sendNotifications' => true } )
  end

  def create_event(event_hash)
    self.google_api_client.execute(:api_method => self.calendar_service.events.insert,
																	 :parameters => { 'calendarId' => 'primary', 'sendNotifications' => true },
												 			     :body => JSON.dump(event_hash),
											     				 :headers => { 'Content-Type' => 'application/json' } )
  end

  def update_event(event_hash, event_id)
  	self.google_api_client.execute(:api_method => self.calendar_service.events.update,
															     :parameters => { 'calendarId' => 'primary', 'eventId' => event_id, 'sendNotifications' => true },
															     :body => JSON.dump(event_hash),
															     :headers => { 'Content-Type' => 'application/json' } )
  end

  def oauth2_client
    OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], :site => 'https://www.google.com')
  end

  def oauth2_token_object
    OAuth2::AccessToken.new(self.oauth2_client, self.token)
  end

  def refresh_access_token
    if self.token_expires_soon?
      response = HTTParty.post('https://accounts.google.com/o/oauth2/token', body: { client_id: ENV['CLIENT_ID'], client_secret: ENV['CLIENT_SECRET'], grant_type: 'refresh_token', refresh_token: self.refresh_token})
      self.update(token: response['access_token'], token_expires_at: Time.now.to_i + response['expires_in'])
    end
  end

  def token_expires_soon?
    (self.token_expires_at - Time.now.to_i) / 60 <= 30
  end

  def fetch_contacts
    google_contacts_user = GoogleContactsApi::User.new(self.oauth2_token_object)

    contact_data = google_contacts_user.contacts.each do |contact|
      contact.emails.each do |email|
        $redis.rpush(google_contacts_key, { full_name: contact.full_name, email: email }.to_json) if email
      end
    end
  end

  def google_contacts_key
    "users:#{self.id}:google_contacts"
  end

  def load_contacts_from_redis
    data = $redis.lrange(google_contacts_key, 0, -1)
    data.map { |json| JSON.parse(json) }
  end

  def full_name_or_email
    if self.first_name && self.last_name
      "#{self.first_name} #{self.last_name}"
    else
      "#{self.email}"
    end
  end

  def logout
    $redis.del(self.google_contacts_key)
    self.update(contacts_jid: nil)     
  end

  def full_name
    if self.first_name && self.last_name
      "#{self.first_name} #{self.last_name}"
    else
      nil
    end
  end
end
