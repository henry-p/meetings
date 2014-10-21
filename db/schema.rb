# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141021221213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actionables", force: true do |t|
    t.integer  "meeting_id"
    t.integer  "creator_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actionables", ["creator_id"], name: "index_actionables_on_creator_id", using: :btree
  add_index "actionables", ["meeting_id"], name: "index_actionables_on_meeting_id", using: :btree

  create_table "agenda_topics", force: true do |t|
    t.integer  "creator_id"
    t.integer  "meeting_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agenda_topics", ["creator_id"], name: "index_agenda_topics_on_creator_id", using: :btree
  add_index "agenda_topics", ["meeting_id"], name: "index_agenda_topics_on_meeting_id", using: :btree

  create_table "conclusions", force: true do |t|
    t.integer  "agenda_topic_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conclusions", ["agenda_topic_id"], name: "index_conclusions_on_agenda_topic_id", using: :btree

  create_table "invites", force: true do |t|
    t.integer  "invitee_id"
    t.integer  "meeting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["invitee_id"], name: "index_invites_on_invitee_id", using: :btree
  add_index "invites", ["meeting_id"], name: "index_invites_on_meeting_id", using: :btree

  create_table "meetings", force: true do |t|
    t.integer  "creator_id"
    t.string   "title"
    t.string   "description"
    t.string   "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "time_zone"
    t.text     "notes",             default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "calendar_event_id"
    t.boolean  "is_done",           default: false
    t.boolean  "is_live"
  end

  add_index "meetings", ["creator_id"], name: "index_meetings_on_creator_id", using: :btree
  add_index "meetings", ["end_time"], name: "index_meetings_on_end_time", using: :btree
  add_index "meetings", ["start_time"], name: "index_meetings_on_start_time", using: :btree
  add_index "meetings", ["time_zone"], name: "index_meetings_on_time_zone", using: :btree

  create_table "responsibilities", force: true do |t|
    t.integer  "actionable_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responsibilities", ["actionable_id"], name: "index_responsibilities_on_actionable_id", using: :btree
  add_index "responsibilities", ["user_id"], name: "index_responsibilities_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "refresh_token"
    t.integer  "token_expires_at"
    t.string   "contacts_jid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["last_name", "first_name"], name: "index_users_on_last_name_and_first_name", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "agenda_topic_id"
    t.integer  "voter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["agenda_topic_id"], name: "index_votes_on_agenda_topic_id", using: :btree
  add_index "votes", ["voter_id"], name: "index_votes_on_voter_id", using: :btree

end
