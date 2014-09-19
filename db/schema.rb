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

ActiveRecord::Schema.define(version: 20140919104813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "associated_tags", force: true do |t|
    t.integer "tag_id"
    t.integer "associated_id"
  end

  create_table "federal_states", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "locations", force: true do |t|
    t.string   "street",           null: false
    t.string   "addition"
    t.string   "zip",              null: false
    t.string   "city",             null: false
    t.string   "telephone"
    t.string   "email"
    t.boolean  "hq"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "organization_id",  null: false
    t.integer  "federal_state_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "offers", force: true do |t|
    t.string   "name",             limit: 80,                 null: false
    t.text     "description",                                 null: false
    t.text     "todo"
    t.string   "telephone"
    t.string   "contact_name"
    t.string   "email"
    t.string   "reach",                                       null: false
    t.boolean  "frequent_changes",            default: false
    t.string   "slug"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers_openings", id: false, force: true do |t|
    t.integer "offer_id",   null: false
    t.integer "opening_id", null: false
  end

  create_table "offers_tags", id: false, force: true do |t|
    t.integer "offer_id", null: false
    t.integer "tag_id",   null: false
  end

  create_table "openings", force: true do |t|
    t.string   "day",        limit: 3, null: false
    t.time     "open",                 null: false
    t.time     "close",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name",                          null: false
    t.text     "description",                   null: false
    t.string   "legal_form",                    null: false
    t.boolean  "charitable",     default: true
    t.integer  "founded"
    t.string   "classification"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "sort",          null: false
    t.string   "url",           null: false
    t.integer  "linkable_id"
    t.string   "linkable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
