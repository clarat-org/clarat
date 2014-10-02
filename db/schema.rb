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

ActiveRecord::Schema.define(version: 20141002131836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "associated_tags", force: true do |t|
    t.integer "tag_id"
    t.integer "associated_id"
  end

  add_index "associated_tags", ["associated_id"], name: "index_associated_tags_on_associated_id", using: :btree
  add_index "associated_tags", ["tag_id"], name: "index_associated_tags_on_tag_id", using: :btree

  create_table "federal_states", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hyperlinks", force: true do |t|
    t.integer "linkable_id",              null: false
    t.string  "linkable_type", limit: 40, null: false
    t.integer "website_id",               null: false
  end

  add_index "hyperlinks", ["linkable_id", "linkable_type"], name: "index_hyperlinks_on_linkable_id_and_linkable_type", using: :btree
  add_index "hyperlinks", ["website_id"], name: "index_hyperlinks_on_website_id", using: :btree

  create_table "languages", force: true do |t|
    t.string   "name",                 null: false
    t.string   "code",       limit: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_offers", id: false, force: true do |t|
    t.integer "language_id", null: false
    t.integer "offer_id",    null: false
  end

  add_index "languages_offers", ["language_id"], name: "index_languages_offers_on_language_id", using: :btree
  add_index "languages_offers", ["offer_id"], name: "index_languages_offers_on_offer_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "street",                      null: false
    t.string   "addition"
    t.string   "zip",                         null: false
    t.string   "city",                        null: false
    t.string   "telephone",        limit: 32
    t.string   "email"
    t.boolean  "hq"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "organization_id",             null: false
    t.integer  "federal_state_id",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "second_telephone", limit: 32
    t.string   "fax",              limit: 32
  end

  add_index "locations", ["federal_state_id"], name: "index_locations_on_federal_state_id", using: :btree
  add_index "locations", ["organization_id"], name: "index_locations_on_organization_id", using: :btree

  create_table "offers", force: true do |t|
    t.string   "name",                  limit: 80,                  null: false
    t.text     "description",                                       null: false
    t.text     "next_steps"
    t.string   "telephone",             limit: 32
    t.string   "contact_name"
    t.string   "email"
    t.string   "reach",                                             null: false
    t.boolean  "frequent_changes",                  default: false
    t.string   "slug"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id",                                   null: false
    t.string   "fax",                   limit: 32
    t.string   "opening_specification", limit: 150
    t.text     "keywords"
    t.boolean  "completed",                         default: false
  end

  add_index "offers", ["location_id"], name: "index_offers_on_location_id", using: :btree
  add_index "offers", ["organization_id"], name: "index_offers_on_organization_id", using: :btree

  create_table "offers_openings", id: false, force: true do |t|
    t.integer "offer_id",   null: false
    t.integer "opening_id", null: false
  end

  add_index "offers_openings", ["offer_id"], name: "index_offers_openings_on_offer_id", using: :btree
  add_index "offers_openings", ["opening_id"], name: "index_offers_openings_on_opening_id", using: :btree

  create_table "offers_tags", id: false, force: true do |t|
    t.integer "offer_id", null: false
    t.integer "tag_id",   null: false
  end

  add_index "offers_tags", ["offer_id"], name: "index_offers_tags_on_offer_id", using: :btree
  add_index "offers_tags", ["tag_id"], name: "index_offers_tags_on_tag_id", using: :btree

  create_table "openings", force: true do |t|
    t.string   "day",        limit: 3, null: false
    t.time     "open"
    t.time     "close"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name",                                  null: false
    t.text     "description",                           null: false
    t.string   "legal_form",                            null: false
    t.boolean  "charitable",            default: true
    t.integer  "founded"
    t.string   "umbrella",    limit: 8
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "keywords"
    t.boolean  "completed",             default: false
  end

  create_table "search_locations", force: true do |t|
    t.string   "query",                 null: false
    t.float    "latitude",              null: false
    t.float    "longitude",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "geoloc",     limit: 23, null: false
  end

  add_index "search_locations", ["geoloc"], name: "index_search_locations_on_geoloc", using: :btree
  add_index "search_locations", ["query"], name: "index_search_locations_on_query", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name",                       null: false
    t.boolean  "main",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",              default: "",    null: false
    t.string   "encrypted_password", default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",              default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

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
    t.string   "sort",       null: false
    t.string   "url",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
