class Meeting < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  has_many :invites
  has_many :invitees, through: :invites
  belongs_to :creator, class_name: "User"
  has_many :actionables
  has_many :agenda_topics

  validates :creator_id, presence: true
  validates :title, presence: true

  def self.format_timestamp(datetime)
    datetime.strftime('%A - %b %d, %Y (%l:%M %p)')
  end

  def duration_in_seconds
    self.end_time - self.start_time
  end

  def truncated_title
    return "#{title[0..15]}..." if title.length > 15
    title
  end

  def just_the_date
    start_time.strftime('%A - %b %d, %Y')
  end

  def duration_formatted
    duration_seconds = self.duration_in_seconds

    mm, ss = duration_seconds.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    output_array = [dd == 1 ? "#{dd} day, " : "#{dd} days, ", hh == 1 ? "#{hh} hour, " : "#{hh} hours, ", mm == 1 ? "#{mm} minute, " : "#{mm} minutes, ", ss == 1 ? "#{ss} second" : "#{ss} seconds"]
    output_array.reject { |measure| measure.starts_with?("0") }.join("").chomp(", ")
  end

  def self.event_hash(event)
    { 'summary' => event.title,
      'location' => event.location,
      'description' => event.invite_notes,
      'start' => { 'dateTime' => event.start_time.to_datetime.strftime("%FT%T"), 'timeZone' => event.to_google_time_zone },
      'end' => { 'dateTime' => event.end_time.to_datetime.strftime("%FT%T"), 'timeZone' => event.to_google_time_zone },
      'attendees' => event.invitees_array
    }
  end

  def invite_notes
    "#{self.description} \n\nlocalhost:3000/meetings/#{self.id}"
  end

  def invitees_array
    self.invitees.map { |invitee| { 'email' => invitee.email } }
  end

  def email_array_for_mailer
    self.invitees.map { |invitee| invitee.email } + [self.creator.email]
  end

  def self.format_params(meeting_params)
    meeting_params[:start_time] = DateTime.strptime(meeting_params[:start_time], '%m/%d/%Y %H:%M %P') if !meeting_params[:start_time].empty?
    meeting_params[:end_time] = DateTime.strptime(meeting_params[:end_time], '%m/%d/%Y %H:%M %P') if !meeting_params[:end_time].empty?
    meeting_params
  end

  def destroy_self_and_invites
    self.invites.destroy_all
    self.destroy
  end

  def empty_datetime?
    !(self.start_time && self.end_time)
  end

  def empty_title?
  	!self.title || self.title.empty? 
  end

  def close_meeting_and_send_email
    self.update(is_done: true)
    SendGridWorker.perform_async(self.id)
  end

  def to_google_time_zone
    case self.time_zone
    when "Hawaii"
      return "Pacific/Honolulu"
    when "Alaska"
      return "America/Anchorage"
    when "Pacific Time (US & Canada)"
      return "America/Los_Angeles"
    when "Arizona"
      return "America/Phoenix"
    when "Mountain Time (US & Canada)"
      return "America/Denver"
    when "Central Time (US & Canada)"
      return "America/Chicago"
    when "Eastern Time (US & Canada)"
      return "America/New_York"
    when "Indiana (East)"
      return "America/Indiana/Indianapolis"
    else
      return "America/Chicago"
    end
  end

  def format_to_local_time(utc_time)
    utc_time.strftime('%m/%d/%Y %I:%M %p') unless utc_time.nil?
  end

  def start
    self.update(is_live: true)
  end

  def time_from_now
    days_from_now = ((Time.now - start_time) / 86400).floor
  end
end
