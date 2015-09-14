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

ActiveRecord::Schema.define(version: 20150903120353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: true do |t|
    t.string   "name",       null: false
    t.float    "minlat",     null: false
    t.float    "maxlat",     null: false
    t.float    "minlong",    null: false
    t.float    "maxlong",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon",       limit: 12
    t.integer  "parent_id"
    t.integer  "sort_order"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "categories_offers", id: false, force: true do |t|
    t.integer "offer_id",    null: false
    t.integer "category_id", null: false
  end

  add_index "categories_offers", ["category_id"], name: "index_categories_offers_on_category_id", using: :btree
  add_index "categories_offers", ["offer_id"], name: "index_categories_offers_on_offer_id", using: :btree

  create_table "category_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "category_anc_desc_idx", unique: true, using: :btree
  add_index "category_hierarchies", ["descendant_id"], name: "category_desc_idx", using: :btree

  create_table "contact_people", force: true do |t|
    t.integer  "organization_id",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "area_code_1",      limit: 6
    t.string   "local_number_1",   limit: 32
    t.string   "area_code_2",      limit: 6
    t.string   "local_number_2",   limit: 32
    t.string   "fax_area_code",    limit: 6
    t.string   "fax_number",       limit: 32
    t.string   "first_name"
    t.string   "last_name"
    t.string   "operational_name"
    t.string   "academic_title"
    t.string   "gender"
    t.string   "role"
    t.string   "responsibility"
    t.integer  "email_id"
    t.boolean  "spoc",                        default: false, null: false
  end

  add_index "contact_people", ["email_id"], name: "index_contact_people_on_email_id", using: :btree
  add_index "contact_people", ["organization_id"], name: "index_contact_people_on_organization_id", using: :btree

  create_table "contact_person_offers", force: true do |t|
    t.integer "offer_id",          null: false
    t.integer "contact_person_id", null: false
  end

  add_index "contact_person_offers", ["contact_person_id"], name: "index_contact_person_offers_on_contact_person_id", using: :btree
  add_index "contact_person_offers", ["offer_id"], name: "index_contact_person_offers_on_offer_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "definitions", force: true do |t|
    t.string   "key",         null: false
    t.text     "explanation", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: true do |t|
    t.string   "address",       limit: 64,                        null: false
    t.string   "aasm_state",    limit: 32, default: "uninformed", null: false
    t.string   "security_code", limit: 36
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "federal_states", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filters", force: true do |t|
    t.string   "name",                  null: false
    t.string   "identifier", limit: 20, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                  null: false
  end

  create_table "filters_offers", id: false, force: true do |t|
    t.integer "filter_id", null: false
    t.integer "offer_id",  null: false
  end

  add_index "filters_offers", ["filter_id"], name: "index_filters_offers_on_filter_id", using: :btree
  add_index "filters_offers", ["offer_id"], name: "index_filters_offers_on_offer_id", using: :btree

  create_table "hyperlinks", force: true do |t|
    t.integer "linkable_id",              null: false
    t.string  "linkable_type", limit: 40, null: false
    t.integer "website_id",               null: false
  end

  add_index "hyperlinks", ["linkable_id", "linkable_type"], name: "index_hyperlinks_on_linkable_id_and_linkable_type", using: :btree
  add_index "hyperlinks", ["website_id"], name: "index_hyperlinks_on_website_id", using: :btree

  create_table "keywords", force: true do |t|
    t.string "name"
    t.text   "synonyms"
  end

  create_table "keywords_offers", id: false, force: true do |t|
    t.integer "keyword_id", null: false
    t.integer "offer_id",   null: false
  end

  add_index "keywords_offers", ["keyword_id"], name: "index_keywords_offers_on_keyword_id", using: :btree
  add_index "keywords_offers", ["offer_id"], name: "index_keywords_offers_on_offer_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "street",                      null: false
    t.text     "addition"
    t.string   "zip",                         null: false
    t.string   "city",                        null: false
    t.boolean  "hq"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "organization_id",             null: false
    t.integer  "federal_state_id",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "display_name",                null: false
    t.string   "area_code",        limit: 6
    t.string   "local_number",     limit: 32
    t.string   "email"
  end

  add_index "locations", ["created_at"], name: "index_locations_on_created_at", using: :btree
  add_index "locations", ["federal_state_id"], name: "index_locations_on_federal_state_id", using: :btree
  add_index "locations", ["organization_id"], name: "index_locations_on_organization_id", using: :btree

  create_table "notes", force: true do |t|
    t.text     "text",                                         null: false
    t.string   "topic",             limit: 32
    t.boolean  "closed",                       default: false
    t.integer  "user_id",                                      null: false
    t.integer  "notable_id",                                   null: false
    t.string   "notable_type",      limit: 64,                 null: false
    t.integer  "referencable_id"
    t.string   "referencable_type", limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["notable_id", "notable_type"], name: "index_notes_on_notable_id_and_notable_type", using: :btree
  add_index "notes", ["referencable_id", "referencable_type"], name: "index_notes_on_referencable_id_and_referencable_type", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "offer_mailings", force: true do |t|
    t.integer  "offer_id",                null: false
    t.integer  "email_id",                null: false
    t.string   "mailing_type", limit: 16, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "offer_mailings", ["email_id"], name: "index_offer_mailings_on_email_id", using: :btree
  add_index "offer_mailings", ["offer_id"], name: "index_offer_mailings_on_offer_id", using: :btree

  create_table "offers", force: true do |t|
    t.string   "name",                       limit: 80,                      null: false
    t.text     "description",                                                null: false
    t.text     "next_steps"
    t.string   "encounter"
    t.string   "slug"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "opening_specification"
    t.text     "comment"
    t.datetime "approved_at"
    t.text     "legal_information"
    t.integer  "created_by"
    t.integer  "approved_by"
    t.boolean  "renewed",                               default: false
    t.date     "expires_at",                                                 null: false
    t.integer  "area_id"
    t.text     "description_html"
    t.text     "next_steps_html"
    t.text     "opening_specification_html"
    t.string   "target_gender",                         default: "whatever"
    t.integer  "age_from",                                                   null: false
    t.integer  "age_to",                                                     null: false
    t.string   "target_audience"
    t.string   "aasm_state",                 limit: 32
  end

  add_index "offers", ["aasm_state"], name: "index_offers_on_aasm_state", using: :btree
  add_index "offers", ["approved_at"], name: "index_offers_on_approved_at", using: :btree
  add_index "offers", ["area_id"], name: "index_offers_on_area_id", using: :btree
  add_index "offers", ["created_at"], name: "index_offers_on_created_at", using: :btree
  add_index "offers", ["location_id"], name: "index_offers_on_location_id", using: :btree

  create_table "offers_openings", id: false, force: true do |t|
    t.integer "offer_id",   null: false
    t.integer "opening_id", null: false
  end

  add_index "offers_openings", ["offer_id"], name: "index_offers_openings_on_offer_id", using: :btree
  add_index "offers_openings", ["opening_id"], name: "index_offers_openings_on_opening_id", using: :btree

  create_table "openings", force: true do |t|
    t.string   "day",        limit: 3, null: false
    t.time     "open"
    t.time     "close"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_value"
    t.string   "name",                 null: false
  end

  add_index "openings", ["day"], name: "index_openings_on_day", using: :btree
  add_index "openings", ["name"], name: "index_openings_on_name", using: :btree

  create_table "organization_connections", force: true do |t|
    t.integer "parent_id", null: false
    t.integer "child_id",  null: false
  end

  add_index "organization_connections", ["child_id"], name: "index_organization_connections_on_child_id", using: :btree
  add_index "organization_connections", ["parent_id"], name: "index_organization_connections_on_parent_id", using: :btree

  create_table "organization_offers", force: true do |t|
    t.integer "offer_id",        null: false
    t.integer "organization_id", null: false
  end

  add_index "organization_offers", ["offer_id"], name: "index_organization_offers_on_offer_id", using: :btree
  add_index "organization_offers", ["organization_id"], name: "index_organization_offers_on_organization_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name",                                              null: false
    t.text     "description",                                       null: false
    t.string   "legal_form",                                        null: false
    t.boolean  "charitable",                        default: true
    t.integer  "founded"
    t.string   "umbrella",               limit: 8
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.datetime "approved_at"
    t.integer  "offers_count",                      default: 0
    t.integer  "locations_count",                   default: 0
    t.integer  "created_by"
    t.integer  "approved_by"
    t.boolean  "renewed",                           default: false
    t.boolean  "accredited_institution",            default: false
    t.text     "description_html"
    t.boolean  "mailings_enabled",                  default: false
    t.string   "aasm_state",             limit: 32
  end

  add_index "organizations", ["aasm_state"], name: "index_organizations_on_aasm_state", using: :btree
  add_index "organizations", ["approved_at"], name: "index_organizations_on_approved_at", using: :btree
  add_index "organizations", ["created_at"], name: "index_organizations_on_created_at", using: :btree

  create_table "search_locations", force: true do |t|
    t.string   "query",                 null: false
    t.float    "latitude",              null: false
    t.float    "longitude",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "geoloc",     limit: 35, null: false
  end

  add_index "search_locations", ["geoloc"], name: "index_search_locations_on_geoloc", using: :btree
  add_index "search_locations", ["query"], name: "index_search_locations_on_query", using: :btree

  create_table "sitemaps", force: true do |t|
    t.string "path",    null: false
    t.text   "content"
  end

  add_index "sitemaps", ["path"], name: "index_sitemaps_on_path", unique: true, using: :btree

  create_table "statistics", force: true do |t|
    t.string  "topic",   limit: 40, null: false
    t.integer "user_id"
    t.date    "x",                  null: false
    t.integer "y",                  null: false
  end

  add_index "statistics", ["user_id"], name: "index_statistics_on_user_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "update_requests", force: true do |t|
    t.string   "search_location", null: false
    t.string   "email",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   default: "standard"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,          null: false
    t.datetime "locked_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "websites", force: true do |t|
    t.string   "host",       null: false
    t.string   "url",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "websites", ["host"], name: "index_websites_on_host", using: :btree
  add_index "websites", ["url"], name: "index_websites_on_url", using: :btree

end
