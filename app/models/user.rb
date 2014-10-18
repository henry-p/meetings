class User < ActiveRecord::Base
  has_many :responsibilities
  has_many :assigned_actionables, through: :responsibilities, source: :actionable

  has_many :created_actionables, class_name: "Actionable", foreign_key: :creator_id

  has_many :votes, foreign_key: :voter_id
  has_many :voted_agenda_topics, through: :votes, source: :agenda_topic

  has_many :invites, foreign_key: :invitee_id
  has_many :meetings, through: :invites

  has_many :meetings, foreign_key: :creator_id

  has_many :agenda_topics, foreign_key: :creator_id

  def google_api_client
    client = Google::APIClient.new
    client.authorization.access_token = self.token
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
    response = self.google_api_client.execute(:api_method => self.calendar_service.events.insert,
    :parameters => { 'calendarId' => 'primary', 'sendNotifications' => true },
    :body => JSON.dump(event_hash),
    :headers => { 'Content-Type' => 'application/json' } )

    add_calendar_event_id(response, Meeting.find_by_id(User.get_meeting_id(event_hash)))
    response
  end

  def oauth2_client
    OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], :site => 'https://www.google.com')
  end

  def oauth2_token_object
    OAuth2::AccessToken.new(self.oauth2_client, self.token)
  end

  def load_contacts
    google_contacts_user = GoogleContactsApi::User.new(self.oauth2_token_object)

    contact_data = google_contacts_user.contacts.map do |contact|
      contact.emails.map do |email|
        { full_name: contact.full_name, email: email } if email
      end
    end.flatten.to_json

    $redis.set("#{self.id}", contact_data)
  end  

  def add_calendar_event_id(response, event)
  	event.update(calendar_event_id: response.data.id)
  end

  def self.get_meeting_id(event_hash)
  	event_hash["description"].chars.last(2).join.to_i
  end
end


