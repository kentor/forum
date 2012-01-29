TLF::Application.routes.draw do
  username_h = { :username => %r([^/]+) }
  
  root :to => "forums#index"
  
  get   "search" => "forums#search", :as => :search
  
  get   "forums"                 => "admin#forums",   :as => :forums
  post  "forums/sort"            => "forums#sort",    :as => :sort_forums
  get   "forum/:id(/page/:page)" => "forums#show",    :as => :show_forum
  get   "forums/new"             => "forums#new",     :as => :new_forum  
  post  "forums/create"          => "forums#create",  :as => :create_forum
  get   "forum/:id/edit"         => "forums#edit",    :as => :edit_forum
  put   "forum/:id/update"       => "forums#update",  :as => :update_forum
  match "forum/:id/destroy"      => "forums#destroy", :as => :destroy_forum
  
  get   "thread/:id(/page/:page)"       => "threads#show",    :as => :show_thread
  get   "forum/:forum_id/thread/new"    => "threads#new",     :as => :new_thread
  post  "forum/:forum_id/thread/create" => "threads#create",  :as => :create_thread
  get   "thread/:id/edit"               => "threads#edit",    :as => :edit_thread
  put   "thread/:id/update"             => "threads#update",  :as => :update_thread
  get   "thread/:id/destroy"            => "threads#destroy", :as => :destroy_thread

  get   "posts(/:username(/page/:page))"             => "posts#index",   :as => :posts  
  get   "thread/:thread_id/post/new(/quote/:sub_id)" => "posts#new",     :as => :new_post
  post  "thread/:thread_id/post/create"              => "posts#create",  :as => :create_post
  get   "thread/:thread_id/post/:id/edit"            => "posts#edit",    :as => :edit_post
  put   "thread/:thread_id/post/:id/update"          => "posts#update",  :as => :update_post
  get   "post/:id/destroy"                           => "posts#destroy", :as => :destroy_post
  get   "post/:id/nuke"                              => "posts#nuke",    :as => :nuke_post

  get   "register"               => "users#new",               :as => :new_user
  post  "users/create"           => "users#create",            :as => :create_user
  get   "user/:id/activate/:key" => "users#activate",          :as => :activate_user
  match "request_password"       => "users#request_password",  :as => :request_password
  get   "user/:id/recover/:key"  => "users#recover_password",  :as => :recover_password
  get   "user/:id/resend"        => "users#resend_activation", :as => :resend_activation
  
  match "login"  => "sessions#new",     :as => :login
  get   "logout" => "sessions#destroy", :as => :logout

  get   "profile/:username" => "users#show",   :as => :show_profile, :constraints => username_h
  get   "myprofile/edit"    => "users#edit",   :as => :edit_profile
  put   "myprofile/update"  => "users#update", :as => :update_profile

  get   "users"                => "users#index",           :as => :users
  get   "user/:username"       => "users#show_detailed",   :as => :show_user, :constraints => username_h
  get   "user/:username/edit"  => "users#edit_detailed",   :as => :edit_user, :constraints => username_h
  put   "user/:id/update"      => "users#update_detailed", :as => :update_user
  get   "user/:username/bans"  => "bans#index",            :as => :bans_history, :constraints => username_h
  get   "user/:username/unban" => "bans#unban",            :as => :unban_user, :constraints => username_h
  
  get   "messages"         => "messages#index",  :as => :messages
  get   "messages/sent"    => "messages#outbox", :as => :sent_messages
  get   "message/:id"      => "messages#show",   :as => :show_message
  get   "messages/new"     => "messages#new",    :as => :new_message
  post  "messages/create"  => "messages#create", :as => :create_message
  get   "message/:id/read" => "messages#toggle", :as => :toggle_message
  
  get   "poll/:id"                        => "polls#show",   :as => :show_poll
  get   "polls/new"                       => "polls#new",    :as => :new_poll
  post  "polls/create"                    => "polls#create", :as => :create_poll 
  post  "poll/:id/choice/:choice_id/vote" => "polls#vote",   :as => :vote

  get   "admin" => "admin#index", :as => :admin
  
  get   "warnings/new"    => "warnings#new",    :as => :new_warning
  post  "warnings/create" => "warnings#create", :as => :create_warning
  
  get   "bans"                 => "bans#index",  :as => :bans
  get   "bans/new(/:username)" => "bans#new",    :as => :new_ban, :constraints => username_h
  post  "bans/create"          => "bans#create", :as => :create_ban

  get   "sessions" => "sessions#index",  :as => :sessions

  get   "settings"        => "settings#index",  :as => :settings
  put   "settings/update" => "settings#update", :as => :update_settings
  
  get   "announcements"            => "announcements#index",   :as => :announcements
  get   "announcements/new"        => "announcements#new",     :as => :new_announcement
  post  "announcements/create"     => "announcements#create",  :as => :create_announcement
  get   "announcement/:id/edit"    => "announcements#edit",    :as => :edit_announcement
  put   "announcement/:id/update"  => "announcements#update",  :as => :update_announcement
  get   "announcement/:id/destroy" => "announcements#destroy", :as => :destroy_announcement
  get   "announcement/:id/toggle"  => "announcements#toggle",  :as => :toggle_announcement
  
  get   "icons"        => "icons#index",   :as => :icons
  post  "icons/create" => "icons#create",  :as => :create_icon
  get   "icon/destroy" => "icons#destroy", :as => :destroy_icon
  
  get   "smilies"        => "smilies#index",   :as => :smilies
  post  "smilies/create" => "smilies#create",  :as => :create_smiley
  get   "smiley/destroy" => "smilies#destroy", :as => :destroy_smiley
  
  get   "smilies-and-bbcode" => "misc#smilies", :as => :smilies_and_bbcode
  get   "stats"              => "misc#stats",   :as => :stats
end
