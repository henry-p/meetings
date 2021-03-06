class Meeting < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  has_many :invites
  has_many :invitees, through: :invites
  belongs_to :creator, class_name: "User"
  has_many :actionables
  has_many :agenda_topics

  validates :creator_id, presence: true
  validates :title, presence: true

  def self.format_timezone(timezone)
    timezone.gsub(/\s\(US & Canada\)$/, "")
  end

  def self.format_date(datetime)
    datetime.strftime('%A - %b %d, %Y')
  end

  def self.format_time(datetime)
    datetime.strftime('%-l:%M %p')
  end

  def self.show_start_datetime(datetime, timezone)
    date = self.format_date(datetime)
    time = self.format_time(datetime)
    timezone = self.format_timezone(timezone)
    "#{date} @ #{time} (#{timezone})"
  end

  def self.format_from_to_time
    datetime.strftime('%l:%M %p')
  end

  def duration_in_seconds
    self.end_time - self.start_time
  end

  def truncated_title
    return "#{title[0..13]}..." if title.length > 13
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
    "#{self.description} \n\nhttp://standup-app.herokuapp.com/meetings/#{self.id}"
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
    ActiveSupport::TimeZone::MAPPING.select {|k, v| k == self.time_zone }.values.first
  end

  def self.to_rails_time_zone(time)
    ActiveSupport::TimeZone::MAPPING.select {|k, v| v == time }.keys.first
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
