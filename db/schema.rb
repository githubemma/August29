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

ActiveRecord::Schema.define(version: 20160710203752) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email",              limit: 255
    t.string "encrypted_password", limit: 255
  end

  create_table "articles", force: :cascade do |t|
    t.string  "header"
    t.string  "text"
    t.integer "status", limit: 2, default: 1
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookmarks", ["page_id"], name: "index_bookmarks_on_page_id", using: :btree
  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "img",  limit: 255
  end

  create_table "column_to_pages", force: :cascade do |t|
    t.integer "column_id"
    t.integer "page_id"
    t.integer "column_order"
  end

  add_index "column_to_pages", ["column_id"], name: "index_column_to_pages_on_column_id", using: :btree
  add_index "column_to_pages", ["page_id"], name: "index_column_to_pages_on_page_id", using: :btree

  create_table "columns", force: :cascade do |t|
    t.string  "name",   limit: 255
    t.integer "status", limit: 2,   default: 1
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "page_id"
    t.string   "name",       limit: 255
    t.string   "message",    limit: 255
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name"
  end

  create_table "homepage_categories", force: :cascade do |t|
    t.integer "category_id"
    t.integer "category_order"
  end

  add_index "homepage_categories", ["category_id"], name: "index_homepage_categories_on_category_id", using: :btree

  create_table "homepages", force: :cascade do |t|
    t.integer "category_id"
    t.integer "page_id"
    t.integer "page_order"
  end

  add_index "homepages", ["category_id"], name: "index_homepages_on_category_id", using: :btree
  add_index "homepages", ["page_id"], name: "index_homepages_on_page_id", using: :btree

  create_table "item_to_columns", force: :cascade do |t|
    t.integer "item_id"
    t.integer "column_id"
    t.integer "page_id"
    t.integer "item_order"
  end

  add_index "item_to_columns", ["column_id"], name: "index_item_to_columns_on_column_id", using: :btree
  add_index "item_to_columns", ["item_id"], name: "index_item_to_columns_on_item_id", using: :btree
  add_index "item_to_columns", ["page_id"], name: "index_item_to_columns_on_page_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.integer "page_id"
    t.string  "title",       limit: 255
    t.string  "description", limit: 255
    t.string  "img",         limit: 255
    t.string  "link"
    t.integer "status",      limit: 2,   default: 1
  end

  add_index "items", ["page_id"], name: "index_items_on_page_id", using: :btree

  create_table "page_to_folders", force: :cascade do |t|
    t.integer "page_id"
    t.integer "folder_id"
  end

  add_index "page_to_folders", ["folder_id"], name: "index_page_to_folders_on_folder_id", using: :btree
  add_index "page_to_folders", ["page_id"], name: "index_page_to_folders_on_page_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.integer "slider_id"
    t.string  "title",       limit: 255
    t.string  "description", limit: 255
    t.string  "img",         limit: 255
    t.string  "slug",        limit: 255
    t.string  "tag",         limit: 255
  end

  add_index "pages", ["slider_id"], name: "index_pages_on_slider_id", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", using: :btree

  create_table "quick_links", force: :cascade do |t|
    t.integer "page_id"
    t.string  "text",    limit: 255
    t.string  "link",    limit: 255
    t.integer "status",  limit: 2,   default: 1
  end

  add_index "quick_links", ["page_id"], name: "index_quick_links_on_page_id", using: :btree

  create_table "report_columns", force: :cascade do |t|
    t.integer  "column_id"
    t.integer  "page_id"
    t.string   "name",       limit: 255
    t.string   "reason",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_columns", ["column_id"], name: "index_report_columns_on_column_id", using: :btree
  add_index "report_columns", ["page_id"], name: "index_report_columns_on_page_id", using: :btree

  create_table "report_histories", force: :cascade do |t|
    t.string   "history",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_items", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "page_id"
    t.string   "reason",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
  end

  add_index "report_items", ["item_id"], name: "index_report_items_on_item_id", using: :btree
  add_index "report_items", ["page_id"], name: "index_report_items_on_page_id", using: :btree

  create_table "request_pages", force: :cascade do |t|
    t.string   "text",       limit: 255
    t.integer  "status",     limit: 2,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slider_images", force: :cascade do |t|
    t.integer "slider_id"
    t.string  "title",      limit: 255
    t.string  "img",        limit: 255
    t.string  "sub_header", limit: 255
    t.string  "source",     limit: 255
  end

  add_index "slider_images", ["slider_id"], name: "index_slider_images_on_slider_id", using: :btree

  create_table "sliders", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.integer "height"
    t.integer "speed"
    t.integer "duration"
    t.boolean "default"
  end

  create_table "suggest_histories", force: :cascade do |t|
    t.string   "history",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_feeds", force: :cascade do |t|
    t.integer "page_id"
    t.string  "hashtag"
    t.string  "widget"
    t.string  "title"
  end

  add_index "twitter_feeds", ["page_id"], name: "index_twitter_feeds_on_page_id", using: :btree

  create_table "user_email_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_email_logs", ["user_id"], name: "index_user_email_logs_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
