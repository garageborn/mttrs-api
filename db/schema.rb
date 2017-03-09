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
  enable_extension "unaccent"

  create_table "accesses", force: :cascade do |t|
    t.string   "accessable_type",             null: false
    t.integer  "accessable_id",               null: false
    t.datetime "date",                        null: false
    t.integer  "hits",            default: 1, null: false
    t.index ["accessable_type", "accessable_id", "date"], name: "index_access_on_assetable_and_created_at", unique: true, using: :btree
    t.index ["date"], name: "index_accesses_on_date", using: :btree
    t.index ["hits"], name: "index_accesses_on_hits", using: :btree
  end

  create_table "blocked_urls", force: :cascade do |t|
    t.integer  "publisher_id", null: false
    t.text     "matcher",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["publisher_id"], name: "index_blocked_urls_on_publisher_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.citext   "name",                   null: false
    t.citext   "slug",                   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "image_id",               null: false
    t.string   "color",                  null: false
    t.integer  "order",      default: 0, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
    t.index ["order"], name: "index_categories_on_order", using: :btree
    t.index ["slug"], name: "index_categories_on_slug", unique: true, using: :btree
  end

  create_table "category_links", force: :cascade do |t|
    t.integer  "category_id", null: false
    t.integer  "link_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id", "link_id"], name: "index_category_links_on_category_id_and_link_id", unique: true, using: :btree
    t.index ["link_id", "category_id"], name: "index_category_links_on_link_id_and_category_id", unique: true, using: :btree
    t.index ["link_id"], name: "index_category_links_on_link_id", unique: true, using: :btree
  end

  create_table "category_matchers", force: :cascade do |t|
    t.integer  "publisher_id",                      null: false
    t.integer  "category_id",                       null: false
    t.text     "url_matcher"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "html_matcher"
    t.text     "html_matcher_selector"
    t.integer  "order",                 default: 0, null: false
    t.index ["category_id", "publisher_id"], name: "index_category_matchers_on_category_id_and_publisher_id", using: :btree
    t.index ["publisher_id", "category_id"], name: "index_category_matchers_on_publisher_id_and_category_id", using: :btree
    t.index ["publisher_id", "order"], name: "index_category_matchers_on_publisher_id_and_order", using: :btree
  end

  create_table "link_urls", force: :cascade do |t|
    t.integer  "link_id",    null: false
    t.citext   "url",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id", "url"], name: "index_link_urls_on_link_id_and_url", unique: true, using: :btree
    t.index ["url"], name: "index_link_urls_on_url", unique: true, using: :btree
  end

  create_table "links", force: :cascade do |t|
    t.integer  "publisher_id",                 null: false
    t.citext   "title",                        null: false
    t.text     "description"
    t.citext   "image_source_url"
    t.integer  "total_social",     default: 0, null: false
    t.datetime "published_at",                 null: false
    t.string   "language"
    t.binary   "html"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.citext   "slug",                         null: false
    t.binary   "content"
    t.index ["published_at"], name: "index_links_on_published_at", using: :btree
    t.index ["publisher_id"], name: "index_links_on_publisher_id", using: :btree
    t.index ["slug"], name: "index_links_on_slug", unique: true, using: :btree
    t.index ["total_social"], name: "index_links_on_total_social", using: :btree
  end

  create_table "publisher_domains", force: :cascade do |t|
    t.integer  "publisher_id", null: false
    t.citext   "domain",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["domain"], name: "index_publisher_domains_on_domain", unique: true, using: :btree
    t.index ["publisher_id"], name: "index_publisher_domains_on_publisher_id", using: :btree
  end

  create_table "publisher_suggestions", force: :cascade do |t|
    t.citext   "name",                   null: false
    t.integer  "count",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["count"], name: "index_publisher_suggestions_on_count", using: :btree
    t.index ["name"], name: "index_publisher_suggestions_on_name", unique: true, using: :btree
  end

  create_table "publishers", force: :cascade do |t|
    t.citext   "name",                        null: false
    t.citext   "slug",                        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "icon_id",                     null: false
    t.string   "language",     default: "en", null: false
    t.citext   "display_name"
    t.index ["name"], name: "index_publishers_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_publishers_on_slug", unique: true, using: :btree
  end

  create_table "social_counters", force: :cascade do |t|
    t.integer  "link_id",                 null: false
    t.integer  "parent_id"
    t.integer  "total",       default: 0, null: false
    t.integer  "facebook",    default: 0, null: false
    t.integer  "linkedin",    default: 0, null: false
    t.integer  "twitter",     default: 0, null: false
    t.integer  "pinterest",   default: 0, null: false
    t.integer  "google_plus", default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["link_id", "total"], name: "index_social_counters_on_link_id_and_total", using: :btree
    t.index ["parent_id"], name: "index_social_counters_on_parent_id", unique: true, using: :btree
  end

  create_table "stories", force: :cascade do |t|
    t.integer  "total_social", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "published_at",             null: false
    t.string   "headline"
    t.text     "summary"
    t.integer  "category_id",              null: false
    t.index ["category_id"], name: "index_stories_on_category_id", using: :btree
    t.index ["published_at"], name: "index_stories_on_published_at", using: :btree
    t.index ["total_social"], name: "index_stories_on_total_social", using: :btree
  end

  create_table "story_links", force: :cascade do |t|
    t.integer  "story_id",               null: false
    t.integer  "link_id",                null: false
    t.integer  "main",       default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["link_id", "story_id"], name: "index_story_links_on_link_id_and_story_id", unique: true, using: :btree
    t.index ["main", "story_id"], name: "index_story_links_on_main_and_story_id", using: :btree
    t.index ["story_id", "link_id"], name: "index_story_links_on_story_id_and_link_id", unique: true, using: :btree
  end

  create_table "title_replacements", force: :cascade do |t|
    t.integer  "publisher_id", null: false
    t.text     "matcher",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["publisher_id"], name: "index_title_replacements_on_publisher_id", using: :btree
  end

end
