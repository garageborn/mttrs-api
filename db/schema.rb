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

ActiveRecord::Schema.define(version: 6) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "categories", force: :cascade do |t|
    t.citext   "name",       null: false
    t.citext   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "feeds", force: :cascade do |t|
    t.integer  "publisher_id", null: false
    t.integer  "category_id",  null: false
    t.citext   "url",          null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "feeds", ["category_id", "publisher_id"], name: "index_feeds_on_category_id_and_publisher_id", using: :btree
  add_index "feeds", ["publisher_id", "category_id"], name: "index_feeds_on_publisher_id_and_category_id", using: :btree
  add_index "feeds", ["url"], name: "index_feeds_on_url", unique: true, using: :btree

  create_table "feeds_stories", id: false, force: :cascade do |t|
    t.integer  "feed_id",    null: false
    t.integer  "story_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "feeds_stories", ["feed_id", "story_id"], name: "index_feeds_stories_on_feed_id_and_story_id", unique: true, using: :btree
  add_index "feeds_stories", ["story_id", "feed_id"], name: "index_feeds_stories_on_story_id_and_feed_id", unique: true, using: :btree

  create_table "publishers", force: :cascade do |t|
    t.citext   "name",       null: false
    t.citext   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "publishers", ["name"], name: "index_publishers_on_name", unique: true, using: :btree
  add_index "publishers", ["slug"], name: "index_publishers_on_slug", unique: true, using: :btree

  create_table "stories", force: :cascade do |t|
    t.integer  "publisher_id",                 null: false
    t.citext   "url"
    t.integer  "status",          default: 0,  null: false
    t.citext   "title"
    t.text     "description"
    t.text     "content"
    t.string   "image_public_id"
    t.jsonb    "social",          default: {}
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.citext   "source_url",                   null: false
  end

  add_index "stories", ["publisher_id"], name: "index_stories_on_publisher_id", using: :btree
  add_index "stories", ["source_url"], name: "index_stories_on_source_url", unique: true, using: :btree
  add_index "stories", ["status"], name: "index_stories_on_status", using: :btree
  add_index "stories", ["url"], name: "index_stories_on_url", using: :btree

end
