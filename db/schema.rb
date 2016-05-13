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

ActiveRecord::Schema.define(version: 3) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "links", force: :cascade do |t|
    t.citext   "url",                          null: false
    t.integer  "status",          default: 0,  null: false
    t.citext   "title"
    t.text     "description"
    t.text     "content"
    t.string   "image_public_id"
    t.jsonb    "social",          default: {}
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "links", ["status"], name: "index_links_on_status", using: :btree
  add_index "links", ["url"], name: "index_links_on_url", unique: true, using: :btree

  create_table "links_sources", id: false, force: :cascade do |t|
    t.integer  "link_id",    null: false
    t.integer  "source_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "links_sources", ["link_id", "source_id"], name: "index_links_sources_on_link_id_and_source_id", unique: true, using: :btree
  add_index "links_sources", ["source_id", "link_id"], name: "index_links_sources_on_source_id_and_link_id", unique: true, using: :btree

  create_table "sources", force: :cascade do |t|
    t.citext   "name",       null: false
    t.citext   "rss",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sources", ["name"], name: "index_sources_on_name", unique: true, using: :btree
  add_index "sources", ["rss"], name: "index_sources_on_rss", unique: true, using: :btree

end
