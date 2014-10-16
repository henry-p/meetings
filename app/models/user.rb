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

  def google_client
    client = Google::APIClient.new
    client.authorization.access_token = self.token
    client
  end

  def calendar_service
    self.google_client.discovered_api('calendar', 'v3')
  end

  

  def contacts_service
    self.google_client.discovered_api('calendar', 'v3')
  end

  def load_contacts
    google_contacts_user = GoogleContactsApi::User.new(self.oauth2_token_object)


    contact_data = google_contacts_user.contacts.map do |contact|
      { full_name: contact.full_name, emails: contact.emails }
    end.to_json

    $redis.set("#{self.id}", contact_data)
  end


  def oauth2_token_object 
    OAuth2::AccessToken.new(self.google_client, self.token)
  end
end




# event = {
#           'summary' => @event.title,
#           'location' => 'Chinatown',
#           'start' => {
#             'dateTime' => '2011-06-03T10:00:00.000-07:00'
#           },
#           'end' => {
#             'dateTime' => '2014-11-11T11:00:00.000-07:00'
#           },
#           'attendess' => [ { 'email' => 'joe.timmer@loringindustries.com' } ]
#         }
#         # define user token here


        # client = Google::APIClient.new
        # client.authorization.access_token = self.token
#         service = client.discovered_api('calendar', 'v3')
#         result = client.execute(:api_method => service.events.insert,
#                                 :parameters => {'calendarId' => 'primary' },
#                                 :body => JSON.dump(event),
#                                 :headers => { 'Content-Type' => 'application/json' } )