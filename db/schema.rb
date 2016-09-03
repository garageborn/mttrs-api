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

ActiveRecord::Schema.define(version: 40) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "categories", force: :cascade do |t|
    t.citext   "name",                       null: false
    t.citext   "slug",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.jsonb    "namespace_ids", default: [], null: false
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
    t.index ["namespace_ids"], name: "index_categories_on_namespace_ids", using: :btree
    t.index ["slug"], name: "index_categories_on_slug", unique: true, using: :btree
  end

  create_table "categories_links", id: false, force: :cascade do |t|
    t.integer  "category_id", null: false
    t.integer  "link_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id", "link_id"], name: "index_categories_links_on_category_id_and_link_id", unique: true, using: :btree
    t.index ["link_id", "category_id"], name: "index_categories_links_on_link_id_and_category_id", unique: true, using: :btree
  end

  create_table "category_matchers", force: :cascade do |t|
    t.integer  "publisher_id",             null: false
    t.integer  "category_id",              null: false
    t.integer  "order",        default: 0, null: false
    t.text     "url_matcher"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["category_id", "publisher_id"], name: "index_category_matchers_on_category_id_and_publisher_id", using: :btree
    t.index ["publisher_id", "category_id"], name: "index_category_matchers_on_publisher_id_and_category_id", using: :btree
  end

  create_table "feeds", force: :cascade do |t|
    t.integer  "publisher_id",                 null: false
    t.integer  "category_id",                  null: false
    t.citext   "url",                          null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "language",      default: "en", null: false
    t.jsonb    "namespace_ids", default: [],   null: false
    t.index ["category_id", "publisher_id"], name: "index_feeds_on_category_id_and_publisher_id", using: :btree
    t.index ["namespace_ids"], name: "index_feeds_on_namespace_ids", using: :btree
    t.index ["publisher_id", "category_id"], name: "index_feeds_on_publisher_id_and_category_id", using: :btree
    t.index ["url"], name: "index_feeds_on_url", unique: true, using: :btree
  end

  create_table "feeds_links", id: false, force: :cascade do |t|
    t.integer  "feed_id",    null: false
    t.integer  "link_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id", "link_id"], name: "index_feeds_links_on_feed_id_and_link_id", unique: true, using: :btree
    t.index ["link_id", "feed_id"], name: "index_feeds_links_on_link_id_and_feed_id", unique: true, using: :btree
  end

  create_table "links", force: :cascade do |t|
    t.integer  "publisher_id",                     null: false
    t.citext   "url",                              null: false
    t.citext   "title",                            null: false
    t.text     "description"
    t.text     "content"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.citext   "source_url",                       null: false
    t.citext   "image_source_url"
    t.integer  "total_social",     default: 0,     null: false
    t.datetime "published_at",                     null: false
    t.string   "language"
    t.integer  "story_id"
    t.binary   "html"
    t.boolean  "main",             default: false, null: false
    t.jsonb    "namespace_ids",    default: [],    null: false
    t.index ["main", "story_id"], name: "index_links_on_main_and_story_id", using: :btree
    t.index ["namespace_ids"], name: "index_links_on_namespace_ids", using: :btree
    t.index ["publisher_id"], name: "index_links_on_publisher_id", using: :btree
    t.index ["source_url"], name: "index_links_on_source_url", unique: true, using: :btree
    t.index ["story_id", "main"], name: "index_links_on_story_id_and_main", using: :btree
    t.index ["total_social"], name: "index_links_on_total_social", using: :btree
    t.index ["url"], name: "index_links_on_url", unique: true, using: :btree
  end

  create_table "namespaces", force: :cascade do |t|
    t.citext   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_namespaces_on_slug", unique: true, using: :btree
  end

  create_table "performed_jobs", force: :cascade do |t|
    t.string   "type",                   null: false
    t.string   "key",                    null: false
    t.integer  "status",     default: 0, null: false
    t.integer  "performs",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["type", "key"], name: "index_performed_jobs_on_type_and_key", unique: true, using: :btree
  end

  create_table "publishers", force: :cascade do |t|
    t.citext   "name",       null: false
    t.citext   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.citext   "domain",     null: false
    t.index ["name"], name: "index_publishers_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_publishers_on_slug", unique: true, using: :btree
  end

  create_table "social_counters", force: :cascade do |t|
    t.integer  "link_id",                 null: false
    t.integer  "facebook",    default: 0, null: false
    t.integer  "linkedin",    default: 0, null: false
    t.integer  "total",       default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "parent_id"
    t.integer  "twitter",     default: 0, null: false
    t.integer  "pinterest",   default: 0, null: false
    t.integer  "google_plus", default: 0, null: false
    t.index ["link_id", "total"], name: "index_social_counters_on_link_id_and_total", using: :btree
    t.index ["parent_id"], name: "index_social_counters_on_parent_id", unique: true, using: :btree
  end

  create_table "stories", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "total_social", default: 0, null: false
    t.index ["total_social"], name: "index_stories_on_total_social", using: :btree
  end

end
