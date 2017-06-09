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

ActiveRecord::Schema.define(version: 56) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "unaccent"

  create_table "accesses", id: :serial, force: :cascade do |t|
    t.string "accessable_type", null: false
    t.integer "accessable_id", null: false
    t.datetime "date", null: false
    t.integer "hits", default: 1, null: false
    t.index ["accessable_type", "accessable_id", "date"], name: "index_access_on_assetable_and_created_at", unique: true
    t.index ["date"], name: "index_accesses_on_date"
    t.index ["hits"], name: "index_accesses_on_hits"
  end

  create_table "amp_links", id: :serial, force: :cascade do |t|
    t.integer "link_id", null: false
    t.integer "status", default: 0, null: false
    t.citext "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_amp_links_on_link_id", unique: true
    t.index ["status"], name: "index_amp_links_on_status"
  end

  create_table "attribute_matchers", id: :serial, force: :cascade do |t|
    t.integer "publisher_id", null: false
    t.string "name", null: false
    t.text "matcher", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id", "name"], name: "index_attribute_matchers_on_publisher_id_and_name"
  end

  create_table "blocked_story_links", id: :serial, force: :cascade do |t|
    t.integer "story_id", null: false
    t.integer "link_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id", "story_id"], name: "index_blocked_story_links_on_link_id_and_story_id", unique: true
    t.index ["story_id", "link_id"], name: "index_blocked_story_links_on_story_id_and_link_id", unique: true
  end

  create_table "blocked_urls", id: :serial, force: :cascade do |t|
    t.integer "publisher_id", null: false
    t.text "matcher", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id"], name: "index_blocked_urls_on_publisher_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.citext "name", null: false
    t.citext "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_id", null: false
    t.string "color", null: false
    t.integer "order", default: 0, null: false
    t.float "similar_min_score", default: 1.5, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["order"], name: "index_categories_on_order"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "category_links", id: :serial, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "link_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id", "link_id"], name: "index_category_links_on_category_id_and_link_id", unique: true
    t.index ["link_id", "category_id"], name: "index_category_links_on_link_id_and_category_id", unique: true
    t.index ["link_id"], name: "index_category_links_on_link_id", unique: true
  end

  create_table "category_matchers", id: :serial, force: :cascade do |t|
    t.integer "publisher_id", null: false
    t.integer "category_id", null: false
    t.text "url_matcher"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "html_matcher"
    t.text "html_matcher_selector"
    t.integer "order", default: 0, null: false
    t.index ["category_id", "publisher_id"], name: "index_category_matchers_on_category_id_and_publisher_id"
    t.index ["publisher_id", "category_id"], name: "index_category_matchers_on_publisher_id_and_category_id"
    t.index ["publisher_id", "order"], name: "index_category_matchers_on_publisher_id_and_order"
  end

  create_table "link_tags", id: :serial, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "link_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id", "tag_id"], name: "index_link_tags_on_link_id_and_tag_id", unique: true
    t.index ["tag_id", "link_id"], name: "index_link_tags_on_tag_id_and_link_id", unique: true
  end

  create_table "link_urls", id: :serial, force: :cascade do |t|
    t.integer "link_id", null: false
    t.citext "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id", "url"], name: "index_link_urls_on_link_id_and_url", unique: true
    t.index ["url"], name: "index_link_urls_on_url", unique: true
  end

  create_table "links", id: :serial, force: :cascade do |t|
    t.integer "publisher_id", null: false
    t.citext "title", null: false
    t.text "description"
    t.citext "image_source_url"
    t.integer "total_social", default: 0, null: false
    t.datetime "published_at", null: false
    t.string "language"
    t.binary "raw_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.citext "slug", null: false
    t.string "html_file_name"
    t.string "html_content_type"
    t.integer "html_file_size"
    t.datetime "html_updated_at"
    t.index ["published_at"], name: "index_links_on_published_at"
    t.index ["publisher_id"], name: "index_links_on_publisher_id"
    t.index ["slug"], name: "index_links_on_slug", unique: true
    t.index ["total_social"], name: "index_links_on_total_social"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.string "notificable_type"
    t.integer "notificable_id"
    t.citext "title"
    t.text "message", null: false
    t.citext "image_url"
    t.citext "onesignal_id"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.citext "icon_url"
    t.citext "segment", null: false
    t.index ["notificable_id", "notificable_type"], name: "index_notifications_on_notificable_id_and_notificable_type"
    t.index ["notificable_type", "notificable_id"], name: "index_notifications_on_notificable_type_and_notificable_id"
  end

  create_table "publisher_domains", id: :serial, force: :cascade do |t|
    t.integer "publisher_id", null: false
    t.citext "domain", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_publisher_domains_on_domain", unique: true
    t.index ["publisher_id"], name: "index_publisher_domains_on_publisher_id"
  end

  create_table "publisher_suggestions", id: :serial, force: :cascade do |t|
    t.citext "name", null: false
    t.integer "count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["count"], name: "index_publisher_suggestions_on_count"
    t.index ["name"], name: "index_publisher_suggestions_on_name", unique: true
  end

  create_table "publishers", id: :serial, force: :cascade do |t|
    t.citext "name", null: false
    t.citext "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon_id", null: false
    t.string "language", default: "en", null: false
    t.citext "display_name"
    t.boolean "restrict_content", default: false, null: false
    t.index ["name"], name: "index_publishers_on_name", unique: true
    t.index ["restrict_content"], name: "index_publishers_on_restrict_content"
    t.index ["slug"], name: "index_publishers_on_slug", unique: true
  end

  create_table "social_counters", id: :serial, force: :cascade do |t|
    t.integer "link_id", null: false
    t.integer "parent_id"
    t.integer "total", default: 0, null: false
    t.integer "facebook", default: 0, null: false
    t.integer "linkedin", default: 0, null: false
    t.integer "twitter", default: 0, null: false
    t.integer "pinterest", default: 0, null: false
    t.integer "google_plus", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id", "total"], name: "index_social_counters_on_link_id_and_total"
    t.index ["parent_id"], name: "index_social_counters_on_parent_id", unique: true
  end

  create_table "stories", id: :serial, force: :cascade do |t|
    t.integer "total_social", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at", null: false
    t.string "headline"
    t.text "summary"
    t.integer "category_id", null: false
    t.datetime "summarized_at"
    t.index ["category_id"], name: "index_stories_on_category_id"
    t.index ["published_at"], name: "index_stories_on_published_at"
    t.index ["summarized_at"], name: "index_stories_on_summarized_at"
    t.index ["total_social"], name: "index_stories_on_total_social"
  end

  create_table "story_links", id: :serial, force: :cascade do |t|
    t.integer "story_id", null: false
    t.integer "link_id", null: false
    t.integer "main", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fixed", default: false, null: false
    t.index ["link_id", "story_id"], name: "index_story_links_on_link_id_and_story_id", unique: true
    t.index ["main", "story_id"], name: "index_story_links_on_main_and_story_id"
    t.index ["story_id", "link_id"], name: "index_story_links_on_story_id_and_link_id", unique: true
  end

  create_table "tag_matchers", id: :serial, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.text "url_matcher"
    t.text "html_matcher_selector"
    t.text "html_matcher"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "publisher_id", null: false
    t.index ["publisher_id"], name: "index_tag_matchers_on_publisher_id"
    t.index ["tag_id"], name: "index_tag_matchers_on_tag_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.integer "category_id", null: false
    t.citext "name", null: false
    t.integer "order", default: 0, null: false
    t.citext "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id", "order"], name: "index_tags_on_category_id_and_order"
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "title_replacements", id: :serial, force: :cascade do |t|
    t.integer "publisher_id", null: false
    t.text "matcher", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id"], name: "index_title_replacements_on_publisher_id"
  end

end
