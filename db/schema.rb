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

ActiveRecord::Schema.define(version: 20160826130459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absences", force: true do |t|
    t.date    "starts_at",                null: false
    t.date    "ends_at",                  null: false
    t.integer "user_id",                  null: false
    t.boolean "sync",      default: true
  end

  add_index "absences", ["user_id"], name: "index_absences_on_user_id", using: :btree

  create_table "areas", force: true do |t|
    t.string   "name",       limit: nil, null: false
    t.float    "minlat",                 null: false
    t.float    "maxlat",                 null: false
    t.float    "minlong",                null: false
    t.float    "maxlong",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name_de",    limit: nil,                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon",       limit: 12
    t.integer  "parent_id"
    t.integer  "sort_order"
    t.boolean  "visible",                default: true
    t.string   "name_en",    limit: nil
    t.string   "name_ar",    limit: nil
    t.string   "name_fr",    limit: nil
    t.string   "name_pl",    limit: nil
    t.string   "name_tr",    limit: nil
    t.string   "name_ru",    limit: nil
    t.string   "name_fa"
  end

  add_index "categories", ["name_de"], name: "index_categories_on_name_de", using: :btree

  create_table "categories_filters", id: false, force: true do |t|
    t.integer "filter_id",   null: false
    t.integer "category_id", null: false
  end

  add_index "categories_filters", ["category_id"], name: "index_filters_categories_on_category_id", using: :btree
  add_index "categories_filters", ["filter_id"], name: "index_filters_categories_on_filter_id", using: :btree

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

  create_table "cities", force: true do |t|
    t.string   "name",       limit: nil, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_people", force: true do |t|
    t.integer  "organization_id",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "area_code_1",      limit: 6
    t.string   "local_number_1",   limit: 32
    t.string   "area_code_2",      limit: 6
    t.string   "local_number_2",   limit: 32
    t.string   "fax_area_code",    limit: 6
    t.string   "fax_number",       limit: 32
    t.string   "first_name",       limit: nil
    t.string   "last_name",        limit: nil
    t.string   "operational_name", limit: nil
    t.string   "academic_title",   limit: nil
    t.string   "gender",           limit: nil
    t.string   "responsibility",   limit: nil
    t.integer  "email_id"
    t.boolean  "spoc",                         default: false, null: false
    t.string   "position",         limit: nil
    t.string   "street"
    t.string   "zip_and_city"
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
    t.string   "name",          limit: nil
    t.string   "email",         limit: nil
    t.text     "message"
    t.string   "url",           limit: 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "internal_mail",              default: false
  end

  create_table "definitions", force: true do |t|
    t.text     "key",         null: false
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
    t.string   "name",       limit: nil, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filters", force: true do |t|
    t.string   "name",              limit: nil, null: false
    t.string   "identifier",        limit: 35,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",              limit: nil, null: false
    t.integer  "section_filter_id"
  end

  add_index "filters", ["section_filter_id"], name: "index_filters_on_section_filter_id", using: :btree

  create_table "filters_offers", id: false, force: true do |t|
    t.integer "filter_id", null: false
    t.integer "offer_id",  null: false
  end

  add_index "filters_offers", ["filter_id"], name: "index_filters_offers_on_filter_id", using: :btree
  add_index "filters_offers", ["offer_id"], name: "index_filters_offers_on_offer_id", using: :btree

  create_table "filters_organizations", id: false, force: true do |t|
    t.integer "filter_id",       null: false
    t.integer "organization_id", null: false
  end

  add_index "filters_organizations", ["filter_id"], name: "index_filters_organizations_on_filter_id", using: :btree
  add_index "filters_organizations", ["organization_id"], name: "index_filters_organizations_on_organization_id", using: :btree

  create_table "gengo_orders", force: true do |t|
    t.integer  "order_id"
    t.string   "expected_slug", limit: nil
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "hyperlinks", force: true do |t|
    t.integer "linkable_id",              null: false
    t.string  "linkable_type", limit: 40, null: false
    t.integer "website_id",               null: false
  end

  add_index "hyperlinks", ["linkable_id", "linkable_type"], name: "index_hyperlinks_on_linkable_id_and_linkable_type", using: :btree
  add_index "hyperlinks", ["website_id"], name: "index_hyperlinks_on_website_id", using: :btree

  create_table "keywords", force: true do |t|
    t.string "name",     limit: nil
    t.text   "synonyms"
  end

  create_table "keywords_offers", id: false, force: true do |t|
    t.integer "keyword_id", null: false
    t.integer "offer_id",   null: false
  end

  add_index "keywords_offers", ["keyword_id"], name: "index_keywords_offers_on_keyword_id", using: :btree
  add_index "keywords_offers", ["offer_id"], name: "index_keywords_offers_on_offer_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "street",           limit: nil,                null: false
    t.text     "addition"
    t.string   "zip",              limit: nil,                null: false
    t.boolean  "hq"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "organization_id",                             null: false
    t.integer  "federal_state_id",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",             limit: nil
    t.string   "display_name",     limit: nil,                null: false
    t.boolean  "visible",                      default: true
    t.boolean  "in_germany",                   default: true
    t.integer  "city_id"
  end

  add_index "locations", ["city_id"], name: "index_locations_on_city_id", using: :btree
  add_index "locations", ["created_at"], name: "index_locations_on_created_at", using: :btree
  add_index "locations", ["federal_state_id"], name: "index_locations_on_federal_state_id", using: :btree
  add_index "locations", ["organization_id"], name: "index_locations_on_organization_id", using: :btree

  create_table "logic_versions", force: true do |t|
    t.integer "version"
    t.string  "name",        limit: nil
    t.text    "description"
  end

  create_table "next_steps", force: true do |t|
    t.string   "text_de",    limit: nil, null: false
    t.string   "text_en",    limit: nil
    t.string   "text_ar",    limit: nil
    t.string   "text_fr",    limit: nil
    t.string   "text_pl",    limit: nil
    t.string   "text_tr",    limit: nil
    t.string   "text_ru",    limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text_fa"
  end

  add_index "next_steps", ["text_de"], name: "index_next_steps_on_text_de", using: :btree

  create_table "next_steps_offers", force: true do |t|
    t.integer "next_step_id",             null: false
    t.integer "offer_id",                 null: false
    t.integer "sort_value",   default: 0
  end

  add_index "next_steps_offers", ["next_step_id"], name: "index_next_steps_offers_on_next_step_id", using: :btree
  add_index "next_steps_offers", ["offer_id"], name: "index_organization_translations_on_offer_id", using: :btree

  create_table "notes", force: true do |t|
    t.text     "text",                         null: false
    t.string   "topic",             limit: 32
    t.integer  "user_id",                      null: false
    t.integer  "notable_id",                   null: false
    t.string   "notable_type",      limit: 64, null: false
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

  create_table "offer_translations", force: true do |t|
    t.integer  "offer_id",                                          null: false
    t.string   "locale",                limit: nil,                 null: false
    t.string   "source",                limit: nil, default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                              default: "",    null: false
    t.text     "description",                       default: "",    null: false
    t.text     "old_next_steps"
    t.text     "opening_specification"
    t.boolean  "possibly_outdated",                 default: false
  end

  add_index "offer_translations", ["locale"], name: "index_offer_translations_on_locale", using: :btree
  add_index "offer_translations", ["offer_id"], name: "index_offer_translations_on_offer_id", using: :btree

  create_table "offers", force: true do |t|
    t.string   "name",                        limit: 120,                 null: false
    t.text     "description",                                             null: false
    t.text     "old_next_steps"
    t.string   "encounter",                   limit: nil
    t.string   "slug",                        limit: nil
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "opening_specification"
    t.datetime "approved_at"
    t.text     "legal_information"
    t.integer  "created_by"
    t.integer  "approved_by"
    t.date     "expires_at",                                              null: false
    t.integer  "area_id"
    t.text     "description_html"
    t.text     "next_steps_html"
    t.text     "opening_specification_html"
    t.string   "exclusive_gender",            limit: nil
    t.integer  "age_from",                                default: 0
    t.integer  "age_to",                                  default: 99
    t.string   "target_audience",             limit: nil
    t.string   "aasm_state",                  limit: 32
    t.boolean  "hide_contact_people",                     default: false
    t.boolean  "age_visible",                             default: false
    t.string   "code_word",                   limit: 140
    t.integer  "solution_category_id"
    t.string   "treatment_type",              limit: nil
    t.string   "participant_structure",       limit: nil
    t.string   "gender_first_part_of_stamp",  limit: nil
    t.string   "gender_second_part_of_stamp", limit: nil
    t.integer  "logic_version_id"
    t.integer  "split_base_id"
    t.boolean  "all_inclusive",                           default: false
    t.date     "starts_at"
    t.datetime "completed_at"
    t.integer  "completed_by"
  end

  add_index "offers", ["aasm_state"], name: "index_offers_on_aasm_state", using: :btree
  add_index "offers", ["approved_at"], name: "index_offers_on_approved_at", using: :btree
  add_index "offers", ["area_id"], name: "index_offers_on_area_id", using: :btree
  add_index "offers", ["created_at"], name: "index_offers_on_created_at", using: :btree
  add_index "offers", ["location_id"], name: "index_offers_on_location_id", using: :btree
  add_index "offers", ["logic_version_id"], name: "index_offers_on_logic_version_id", using: :btree
  add_index "offers", ["solution_category_id"], name: "index_offers_on_solution_category_id", using: :btree
  add_index "offers", ["split_base_id"], name: "index_offers_on_split_base_id", using: :btree

  create_table "offers_openings", id: false, force: true do |t|
    t.integer "offer_id",   null: false
    t.integer "opening_id", null: false
  end

  add_index "offers_openings", ["offer_id"], name: "index_offers_openings_on_offer_id", using: :btree
  add_index "offers_openings", ["opening_id"], name: "index_offers_openings_on_opening_id", using: :btree

  create_table "openings", force: true do |t|
    t.string   "day",        limit: 3,   null: false
    t.time     "open"
    t.time     "close"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_value"
    t.string   "name",       limit: nil, null: false
  end

  add_index "openings", ["day"], name: "index_openings_on_day", using: :btree
  add_index "openings", ["name"], name: "index_openings_on_name", using: :btree

  create_table "organization_offers", force: true do |t|
    t.integer "offer_id",        null: false
    t.integer "organization_id", null: false
  end

  add_index "organization_offers", ["offer_id"], name: "index_organization_offers_on_offer_id", using: :btree
  add_index "organization_offers", ["organization_id"], name: "index_organization_offers_on_organization_id", using: :btree

  create_table "organization_translations", force: true do |t|
    t.integer  "organization_id",                               null: false
    t.string   "locale",            limit: nil,                 null: false
    t.string   "source",            limit: nil, default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",                   default: "",    null: false
    t.boolean  "possibly_outdated",             default: false
  end

  add_index "organization_translations", ["locale"], name: "index_organization_translations_on_locale", using: :btree
  add_index "organization_translations", ["organization_id"], name: "index_organization_translations_on_organization_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name",                   limit: nil,                      null: false
    t.text     "description",                                             null: false
    t.string   "legal_form",             limit: nil,                      null: false
    t.boolean  "charitable",                         default: false
    t.integer  "founded"
    t.string   "slug",                   limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "approved_at"
    t.integer  "offers_count",                       default: 0
    t.integer  "locations_count",                    default: 0
    t.integer  "created_by"
    t.integer  "approved_by"
    t.boolean  "accredited_institution",             default: false
    t.text     "description_html"
    t.string   "aasm_state",             limit: 32
    t.string   "mailings",                           default: "disabled", null: false
  end

  add_index "organizations", ["aasm_state"], name: "index_organizations_on_aasm_state", using: :btree
  add_index "organizations", ["approved_at"], name: "index_organizations_on_approved_at", using: :btree
  add_index "organizations", ["created_at"], name: "index_organizations_on_created_at", using: :btree

  create_table "productivity_goals", force: true do |t|
    t.string  "title",              limit: nil, null: false
    t.date    "starts_at",                      null: false
    t.date    "ends_at",                        null: false
    t.string  "target_model",       limit: nil, null: false
    t.integer "target_count",                   null: false
    t.string  "target_field_name",  limit: nil, null: false
    t.string  "target_field_value", limit: nil, null: false
    t.integer "user_team_id",                   null: false
  end

  add_index "productivity_goals", ["user_team_id"], name: "index_productivity_goals_on_user_team_id", using: :btree

  create_table "search_locations", force: true do |t|
    t.string   "query",      limit: nil, null: false
    t.float    "latitude",               null: false
    t.float    "longitude",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "geoloc",     limit: 35,  null: false
  end

  add_index "search_locations", ["geoloc"], name: "index_search_locations_on_geoloc", using: :btree
  add_index "search_locations", ["query"], name: "index_search_locations_on_query", using: :btree

  create_table "sitemaps", force: true do |t|
    t.string "path",    limit: nil, null: false
    t.text   "content"
  end

  add_index "sitemaps", ["path"], name: "index_sitemaps_on_path", unique: true, using: :btree

  create_table "solution_categories", force: true do |t|
    t.string   "name",       limit: nil
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "parent_id"
  end

  create_table "solution_category_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "solution_category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "solution_category_anc_desc_idx", unique: true, using: :btree
  add_index "solution_category_hierarchies", ["descendant_id"], name: "solution_category_desc_idx", using: :btree

  create_table "split_bases", force: true do |t|
    t.string   "title",                limit: nil, null: false
    t.string   "clarat_addition",      limit: nil
    t.text     "comments"
    t.integer  "organization_id",                  null: false
    t.integer  "solution_category_id",             null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "split_bases", ["organization_id"], name: "index_split_bases_on_organization_id", using: :btree
  add_index "split_bases", ["solution_category_id"], name: "index_split_bases_on_solution_category_id", using: :btree

  create_table "statistics", force: true do |t|
    t.string  "topic",             limit: nil
    t.integer "user_id"
    t.date    "date",                                            null: false
    t.float   "count",                         default: 0.0,     null: false
    t.integer "user_team_id"
    t.string  "model",             limit: nil
    t.string  "field_name",        limit: nil
    t.string  "field_start_value", limit: nil
    t.string  "field_end_value",   limit: nil
    t.string  "time_frame",        limit: nil, default: "daily"
  end

  add_index "statistics", ["user_id"], name: "index_statistics_on_user_id", using: :btree
  add_index "statistics", ["user_team_id"], name: "index_statistics_on_user_team_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.string   "email",      limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_allocations", force: true do |t|
    t.integer "user_id",                    null: false
    t.integer "year",                       null: false
    t.integer "week_number",      limit: 2, null: false
    t.integer "desired_wa_hours",           null: false
    t.integer "actual_wa_hours"
  end

  add_index "time_allocations", ["user_id"], name: "index_time_allocations_on_user_id", using: :btree

  create_table "update_requests", force: true do |t|
    t.string   "search_location", limit: nil, null: false
    t.string   "email",           limit: nil, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_team_users", force: true do |t|
    t.integer "user_team_id"
    t.integer "user_id"
  end

  add_index "user_team_users", ["user_id"], name: "index_user_team_users_on_user_id", using: :btree
  add_index "user_team_users", ["user_team_id"], name: "index_user_team_users_on_user_team_id", using: :btree

  create_table "user_teams", force: true do |t|
    t.string "name", limit: nil, null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",              limit: nil, default: "",         null: false
    t.string   "encrypted_password", limit: nil, default: "",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",               limit: nil, default: "standard"
    t.integer  "failed_attempts",                default: 0,          null: false
    t.datetime "locked_at"
    t.string   "provider",           limit: nil
    t.string   "uid",                limit: nil
    t.string   "name",               limit: nil
    t.integer  "current_team_id"
  end

  add_index "users", ["current_team_id"], name: "index_users_on_current_team_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      limit: nil, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: nil, null: false
    t.string   "whodunnit",      limit: nil
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "websites", force: true do |t|
    t.string   "host",              limit: nil,             null: false
    t.string   "url",               limit: nil,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unreachable_count",             default: 0, null: false
  end

  add_index "websites", ["host"], name: "index_websites_on_host", using: :btree
  add_index "websites", ["url"], name: "index_websites_on_url", using: :btree

end
