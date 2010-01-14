# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100114010135) do

  create_table "activities", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "friend_id"
    t.string   "activity_type", :limit => 30
    t.integer  "activity_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["creator_id", "friend_id", "activity_type", "activity_id"], :name => "unique_activity", :unique => true

  create_table "badgeings", :force => true do |t|
    t.integer "badge_id"
    t.integer "user_id"
    t.integer "friend_id"
    t.text    "data"
  end

  add_index "badgeings", ["badge_id"], :name => "index_badgeings_on_badge_id"
  add_index "badgeings", ["user_id"], :name => "index_badgeings_on_user_id"

  create_table "badges", :force => true do |t|
    t.string  "name"
    t.string  "image_thumb"
    t.boolean "giveable",    :default => true
    t.integer "times_given", :default => 0
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", :force => true do |t|
    t.integer  "score"
    t.integer  "scorable_id"
    t.string   "scorable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statements", :force => true do |t|
    t.string   "question"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "by"
    t.string   "by_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score",      :default => 0
    t.text     "vote_data"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
    t.boolean  "tag_vote",      :default => true
    t.string   "voter_name"
    t.string   "voter_link"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count",                       :default => 0, :null => false
    t.integer  "failed_login_count",                :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "name"
    t.integer  "facebook_uid",         :limit => 8, :default => 0, :null => false
    t.string   "facebook_session_key"
    t.string   "image_thumb"
    t.string   "image_small"
    t.string   "image_large"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_whois",                     :default => 0
    t.text     "badges_given"
    t.text     "settings"
  end

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "uniq_one_vote_only", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

  create_table "whois", :force => true do |t|
    t.integer  "version"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "by_link"
  end

end
