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

ActiveRecord::Schema.define(:version => 20120608191108) do

  create_table "action_items", :force => true do |t|
    t.integer  "slide_id"
    t.string   "action_type"
    t.integer  "top"
    t.integer  "left"
    t.integer  "width"
    t.integer  "height"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_gif_file_name"
    t.string   "user_gif_content_type"
    t.string   "user_gif_file_size"
  end

  add_index "action_items", ["slide_id"], :name => "index_action_items_on_slide_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "slides", :force => true do |t|
    t.integer  "story_board_id"
    t.string   "title"
    t.integer  "order_number"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_width"
    t.integer  "image_height"
    t.integer  "transfer_to_slide_id"
    t.integer  "transfer_wait"
    t.integer  "story_board_attachment_id"
  end

  add_index "slides", ["story_board_attachment_id"], :name => "index_slides_on_story_board_attachment_id"
  add_index "slides", ["story_board_id", "order_number"], :name => "index slides_on_order_number_for_story_board "
  add_index "slides", ["story_board_id"], :name => "index_slides_on_story_board_id"

  create_table "story_board_attachments", :force => true do |t|
    t.integer  "story_board_id"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.boolean  "processed",           :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_board_attachments", ["story_board_id"], :name => "index_story_board_attachments_on_story_board_id"

  create_table "story_boards", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background"
    t.boolean  "dirty",          :default => false
    t.string   "security_level", :default => "public"
    t.string   "password"
    t.boolean  "duplicating",    :default => false,    :null => false
  end

  add_index "story_boards", ["user_id"], :name => "index_story_boards_on_user_id"

  create_table "user_prospects", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",           :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
