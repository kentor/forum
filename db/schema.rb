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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "announcements", :force => true do |t|
    t.text     "message",                      :null => false
    t.boolean  "live",       :default => true, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "announcements", ["live"], :name => "live"

  create_table "bans", :force => true do |t|
    t.integer  "user_id",                                    :null => false
    t.integer  "banner_id",                                  :null => false
    t.integer  "post_id"
    t.string   "duration",   :limit => 9
    t.text     "reason"
    t.boolean  "permanent",               :default => false, :null => false
    t.datetime "expires_at",                                 :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "bans", ["banner_id"], :name => "banner_id"
  add_index "bans", ["expires_at"], :name => "expires_at"
  add_index "bans", ["permanent"], :name => "permanent"
  add_index "bans", ["post_id"], :name => "post_id"
  add_index "bans", ["user_id"], :name => "user_id"

  create_table "choices", :force => true do |t|
    t.integer  "poll_id",                                   :null => false
    t.string   "name",        :limit => 100,                :null => false
    t.integer  "votes_count",                :default => 0, :null => false
    t.datetime "created_at",                                :null => false
  end

  add_index "choices", ["poll_id"], :name => "poll_id"
  add_index "choices", ["votes_count"], :name => "votes_count"

  create_table "forums", :force => true do |t|
    t.string   "title",             :limit => 50,                  :null => false
    t.string   "allowed_to_view",   :limit => 20, :default => "1"
    t.string   "allowed_to_read",   :limit => 20
    t.string   "allowed_to_reply",  :limit => 20
    t.string   "allowed_to_create", :limit => 20
    t.integer  "position",          :limit => 1,  :default => 0,   :null => false
    t.integer  "threads_in_index",  :limit => 1,  :default => 10,  :null => false
    t.integer  "threads_in_forum",  :limit => 1,  :default => 35,  :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "forums", ["position"], :name => "position"

  create_table "logins", :force => true do |t|
    t.integer  "user_id",                                           :null => false
    t.string   "ip",         :limit => 15, :default => "127.0.0.1", :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "logins", ["ip"], :name => "ip"
  add_index "logins", ["user_id"], :name => "user_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id",                                             :null => false
    t.integer  "recipient_id",                                        :null => false
    t.string   "subject",      :limit => 50,                          :null => false
    t.text     "body",                                                :null => false
    t.boolean  "read",                       :default => false,       :null => false
    t.string   "ip",           :limit => 15, :default => "127.0.0.1", :null => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "messages", ["recipient_id", "read"], :name => "recipient_id read"
  add_index "messages", ["user_id"], :name => "user_id"

  create_table "polls", :force => true do |t|
    t.string   "name",        :limit => 70,                          :null => false
    t.string   "ip",          :limit => 15, :default => "127.0.0.1", :null => false
    t.integer  "votes_count",               :default => 0,           :null => false
    t.datetime "created_at",                                         :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "topic_id",                                           :null => false
    t.integer  "sub_id",                                             :null => false
    t.integer  "user_id",                                            :null => false
    t.text     "body",                                               :null => false
    t.boolean  "is_thread",                 :default => false,       :null => false
    t.boolean  "html",                      :default => false,       :null => false
    t.boolean  "smilies",                   :default => true,        :null => false
    t.boolean  "warned",                    :default => false,       :null => false
    t.boolean  "banned",                    :default => false,       :null => false
    t.boolean  "temp_banned",               :default => false,       :null => false
    t.boolean  "nuked",                     :default => false,       :null => false
    t.string   "ip",          :limit => 15, :default => "127.0.0.1", :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "modified_at"
  end

  add_index "posts", ["is_thread"], :name => "is_thread"
  add_index "posts", ["sub_id"], :name => "sub_id"
  add_index "posts", ["topic_id", "user_id"], :name => "users_posts"
  add_index "posts", ["topic_id"], :name => "topic_id"
  add_index "posts", ["user_id"], :name => "user_id"

  create_table "sessions", :force => true do |t|
    t.string   "ip",         :limit => 15, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "sessions", ["ip"], :name => "ip"
  add_index "sessions", ["updated_at"], :name => "updated_at"

  create_table "settings", :force => true do |t|
    t.string  "admin_groups", :limit => 20, :default => "1",     :null => false
    t.string  "mod_groups",   :limit => 20, :default => "1,2",   :null => false
    t.string  "staff_groups", :limit => 20, :default => "1,2,3", :null => false
    t.string  "html_groups",  :limit => 20, :default => "1,2,3", :null => false
    t.integer "bot_id"
    t.integer "ban_thread"
  end

  create_table "smileys", :force => true do |t|
    t.string "filename", :limit => 50, :null => false
    t.string "code",     :limit => 20, :null => false
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id",                                                        :null => false
    t.integer  "user_id",                                                         :null => false
    t.string   "title",          :limit => 50,                                    :null => false
    t.integer  "views",                        :default => 0,                     :null => false
    t.boolean  "sticky",                       :default => false,                 :null => false
    t.boolean  "locked",                       :default => false,                 :null => false
    t.string   "ip",             :limit => 15, :default => "127.0.0.1",           :null => false
    t.integer  "posts_count",                  :default => 0,                     :null => false
    t.integer  "last_poster_id",               :default => 0,                     :null => false
    t.datetime "last_posted_at",               :default => '1980-01-01 00:00:00', :null => false
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  add_index "topics", ["forum_id", "sticky", "last_posted_at"], :name => "sorting"
  add_index "topics", ["forum_id"], :name => "forum_id"
  add_index "topics", ["user_id"], :name => "user_id"

  create_table "users", :force => true do |t|
    t.string   "username",        :limit => 20,                          :null => false
    t.string   "password_digest",                                        :null => false
    t.string   "email",           :limit => 70,                          :null => false
    t.string   "groups",          :limit => 20, :default => "4",         :null => false
    t.string   "location",        :limit => 30
    t.date     "birthday"
    t.text     "profile"
    t.string   "signature"
    t.string   "icon",            :limit => 50
    t.string   "photo_type",      :limit => 4
    t.string   "username_style"
    t.string   "registration_ip", :limit => 15, :default => "127.0.0.1", :null => false
    t.string   "activation_key",  :limit => 4
    t.string   "recovery_key",    :limit => 10
    t.integer  "posts_count",                   :default => 0,           :null => false
    t.boolean  "banned",                        :default => false,       :null => false
    t.string   "last_seen_ip",    :limit => 15
    t.datetime "last_seen_at"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
  end

  add_index "users", ["banned"], :name => "banned"
  add_index "users", ["last_seen_at"], :name => "last_seen_at"
  add_index "users", ["username"], :name => "login"
  add_index "users", ["username"], :name => "username"

  create_table "votes", :force => true do |t|
    t.integer  "poll_id",                  :null => false
    t.integer  "choice_id",                :null => false
    t.string   "ip",         :limit => 15, :null => false
    t.datetime "created_at",               :null => false
  end

  add_index "votes", ["choice_id"], :name => "choice_id"
  add_index "votes", ["poll_id", "ip"], :name => "unique", :unique => true
  add_index "votes", ["poll_id"], :name => "poll_id"

  create_table "warnings", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "warner_id",  :null => false
    t.integer  "post_id"
    t.text     "message",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "warnings", ["post_id"], :name => "post_id"
  add_index "warnings", ["user_id"], :name => "user_id"
  add_index "warnings", ["warner_id"], :name => "warner_id"

end
