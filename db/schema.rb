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

ActiveRecord::Schema.define(:version => 20100623234744) do

  create_table "beliefs", :force => true do |t|
    t.float    "ideal"
    t.float    "weight"
    t.integer  "opinion_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concepts", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concepts_dimensions", :id => false, :force => true do |t|
    t.integer "concept_id"
    t.integer "dimension_id"
  end

  create_table "current_ratings", :force => true do |t|
    t.float    "total_rating", :default => 0.0
    t.integer  "num_ratings",  :default => 0
    t.integer  "entity_id"
    t.integer  "opinion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dimensions", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.float    "ideal"
    t.float    "weight"
    t.boolean  "bool",          :default => false
    t.integer  "valuable_id"
    t.string   "valuable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "concept_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "fact_values", :force => true do |t|
    t.float    "value"
    t.integer  "fact_id"
    t.integer  "entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facts", :force => true do |t|
    t.string   "template",   :default => "#"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opinions", :force => true do |t|
    t.string   "low_text",     :default => "low"
    t.string   "high_text",    :default => "high"
    t.float    "total_ideal",  :default => 0.0
    t.integer  "num_ideals",   :default => 0
    t.float    "total_weight", :default => 0.0
    t.integer  "num_weights",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.float    "value"
    t.integer  "entity_id"
    t.integer  "user_id"
    t.integer  "opinion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "country"
    t.date     "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
