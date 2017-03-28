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

ActiveRecord::Schema.define(version: 20170308130003) do

  create_table "absences", force: :cascade do |t|
    t.date    "starts_at",                null: false
    t.date    "ends_at",                  null: false
    t.integer "user_id",                  null: false
    t.boolean "sync",      default: true
  end

  add_index "absences", ["user_id"], name: "index_absences_on_user_id"

  create_table "areas", force: :cascade do |t|
    t.string   "name",       null: false
    t.float    "minlat",     null: false
    t.float    "maxlat",     null: false
    t.float    "minlong",    null: false
    t.float    "maxlong",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: :cascade do |t|
    t.integer  "assignable_id",                                       null: false
    t.string   "assignable_type",       limit: 32,                    null: false
    t.string   "assignable_field_type", limit: 64,   default: "",     null: false
    t.integer  "creator_id"
    t.integer  "creator_team_id"
    t.integer  "receiver_id"
    t.integer  "receiver_team_id"
    t.string   "message",               limit: 1000
    t.integer  "parent_id"
    t.string   "aasm_state",            limit: 32,   default: "open", null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "assignments", ["aasm_state"], name: "index_assignments_on_aasm_state"
  add_index "assignments", ["assignable_id", "assignable_type"], name: "index_assignments_on_assignable_id_and_assignable_type"
  add_index "assignments", ["creator_id"], name: "index_assignments_on_creator_id"
  add_index "assignments", ["creator_team_id"], name: "index_assignments_on_creator_team_id"
  add_index "assignments", ["parent_id"], name: "index_assignments_on_parent_id"
  add_index "assignments", ["receiver_id"], name: "index_assignments_on_receiver_id"
  add_index "assignments", ["receiver_team_id"], name: "index_assignments_on_receiver_team_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name_de",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon",       limit: 12
    t.integer  "parent_id"
    t.integer  "sort_order"
    t.boolean  "visible",               default: true
    t.string   "name_en"
    t.string   "name_ar"
    t.string   "name_fr"
    t.string   "name_pl"
    t.string   "name_tr"
    t.string   "name_ru"
    t.string   "name_fa"
  end

  add_index "categories", ["name_de"], name: "index_categories_on_name_de"

  create_table "categories_filters", id: false, force: :cascade do |t|
    t.integer "filter_id",   null: false
    t.integer "category_id", null: false
  end

  add_index "categories_filters", ["category_id"], name: "index_filters_categories_on_category_id"
  add_index "categories_filters", ["filter_id"], name: "index_filters_categories_on_filter_id"

  create_table "categories_offers", id: false, force: :cascade do |t|
    t.integer "offer_id",    null: false
    t.integer "category_id", null: false
  end

  add_index "categories_offers", ["category_id"], name: "index_categories_offers_on_category_id"
  add_index "categories_offers", ["offer_id"], name: "index_categories_offers_on_offer_id"

  create_table "category_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "category_anc_desc_idx", unique: true
  add_index "category_hierarchies", ["descendant_id"], name: "category_desc_idx"

  create_table "cities", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_people", force: :cascade do |t|
    t.integer  "organization_id",                              null: false
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
    t.string   "responsibility"
    t.integer  "email_id"
    t.boolean  "spoc",                         default: false, null: false
    t.string   "position"
    t.string   "street",           limit: 255
    t.string   "zip_and_city",     limit: 255
  end

  add_index "contact_people", ["email_id"], name: "index_contact_people_on_email_id"
  add_index "contact_people", ["organization_id"], name: "index_contact_people_on_organization_id"

  create_table "contact_person_offers", force: :cascade do |t|
    t.integer "offer_id",          null: false
    t.integer "contact_person_id", null: false
  end

  add_index "contact_person_offers", ["contact_person_id"], name: "index_contact_person_offers_on_contact_person_id"
  add_index "contact_person_offers", ["offer_id"], name: "index_contact_person_offers_on_offer_id"

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.string   "url",           limit: 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "internal_mail",              default: false
    t.string   "city"
  end

  create_table "definitions", force: :cascade do |t|
    t.text     "key",         limit: 400, null: false
    t.text     "explanation",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", force: :cascade do |t|
    t.string   "name",              null: false
    t.text     "description"
    t.integer  "organization_id"
    t.integer  "section_filter_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "divisions", ["organization_id"], name: "index_divisions_on_organization_id"

  create_table "emails", force: :cascade do |t|
    t.string   "address",       limit: 64,                        null: false
    t.string   "aasm_state",    limit: 32, default: "uninformed", null: false
    t.string   "security_code", limit: 36
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "federal_states", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filters", force: :cascade do |t|
    t.string   "name",                         null: false
    t.string   "identifier",        limit: 35, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                         null: false
    t.integer  "section_filter_id"
  end

  add_index "filters", ["section_filter_id"], name: "index_filters_on_section_filter_id"

  create_table "filters_offers", id: false, force: :cascade do |t|
    t.integer "filter_id", null: false
    t.integer "offer_id",  null: false
  end

  add_index "filters_offers", ["filter_id"], name: "index_filters_offers_on_filter_id"
  add_index "filters_offers", ["offer_id"], name: "index_filters_offers_on_offer_id"

  create_table "filters_organizations", id: false, force: :cascade do |t|
    t.integer "filter_id",       null: false
    t.integer "organization_id", null: false
  end

  add_index "filters_organizations", ["filter_id"], name: "index_filters_organizations_on_filter_id"
  add_index "filters_organizations", ["organization_id"], name: "index_filters_organizations_on_organization_id"

  create_table "gengo_orders", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "expected_slug"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "hyperlinks", force: :cascade do |t|
    t.integer "linkable_id",              null: false
    t.string  "linkable_type", limit: 40, null: false
    t.integer "website_id",               null: false
  end

  add_index "hyperlinks", ["linkable_id", "linkable_type"], name: "index_hyperlinks_on_linkable_id_and_linkable_type"
  add_index "hyperlinks", ["website_id"], name: "index_hyperlinks_on_website_id"

  create_table "keywords", force: :cascade do |t|
    t.string "name"
    t.text   "synonyms"
  end

  create_table "keywords_offers", id: false, force: :cascade do |t|
    t.integer "keyword_id", null: false
    t.integer "offer_id",   null: false
  end

  add_index "keywords_offers", ["keyword_id"], name: "index_keywords_offers_on_keyword_id"
  add_index "keywords_offers", ["offer_id"], name: "index_keywords_offers_on_offer_id"

  create_table "locations", force: :cascade do |t|
    t.string   "street",                          null: false
    t.text     "addition"
    t.string   "zip",                             null: false
    t.boolean  "hq"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "organization_id",                 null: false
    t.integer  "federal_state_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "display_name",                    null: false
    t.boolean  "visible",          default: true
    t.boolean  "in_germany",       default: true
    t.integer  "city_id"
  end

  add_index "locations", ["city_id"], name: "index_locations_on_city_id"
  add_index "locations", ["created_at"], name: "index_locations_on_created_at"
  add_index "locations", ["federal_state_id"], name: "index_locations_on_federal_state_id"
  add_index "locations", ["organization_id"], name: "index_locations_on_organization_id"

  create_table "logic_versions", force: :cascade do |t|
    t.integer "version"
    t.string  "name"
    t.text    "description"
  end

  create_table "next_steps", force: :cascade do |t|
    t.string   "text_de",    null: false
    t.string   "text_en"
    t.string   "text_ar"
    t.string   "text_fr"
    t.string   "text_pl"
    t.string   "text_tr"
    t.string   "text_ru"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text_fa"
  end

  add_index "next_steps", ["text_de"], name: "index_next_steps_on_text_de"

  create_table "next_steps_offers", force: :cascade do |t|
    t.integer "next_step_id",             null: false
    t.integer "offer_id",                 null: false
    t.integer "sort_value",   default: 0
  end

  add_index "next_steps_offers", ["next_step_id"], name: "index_next_steps_offers_on_next_step_id"
  add_index "next_steps_offers", ["offer_id"], name: "index_organization_translations_on_offer_id"

  create_table "notes", force: :cascade do |t|
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

  add_index "notes", ["notable_id", "notable_type"], name: "index_notes_on_notable_id_and_notable_type"
  add_index "notes", ["referencable_id", "referencable_type"], name: "index_notes_on_referencable_id_and_referencable_type"
  add_index "notes", ["user_id"], name: "index_notes_on_user_id"

  create_table "offer_mailings", force: :cascade do |t|
    t.integer  "offer_id",                null: false
    t.integer  "email_id",                null: false
    t.string   "mailing_type", limit: 16, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "offer_mailings", ["email_id"], name: "index_offer_mailings_on_email_id"
  add_index "offer_mailings", ["offer_id"], name: "index_offer_mailings_on_offer_id"

  create_table "offer_translations", force: :cascade do |t|
    t.integer  "offer_id",                                          null: false
    t.string   "locale",                                            null: false
    t.string   "source",                            default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                  limit: 255, default: "",    null: false
    t.text     "description",                       default: "",    null: false
    t.text     "old_next_steps"
    t.text     "opening_specification"
    t.boolean  "possibly_outdated",                 default: false
  end

  add_index "offer_translations", ["locale"], name: "index_offer_translations_on_locale"
  add_index "offer_translations", ["offer_id"], name: "index_offer_translations_on_offer_id"

  create_table "offers", force: :cascade do |t|
    t.string   "name",                        limit: 120,                 null: false
    t.text     "description",                                             null: false
    t.text     "old_next_steps"
    t.string   "encounter"
    t.string   "slug"
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
    t.string   "exclusive_gender"
    t.integer  "age_from",                                default: 0
    t.integer  "age_to",                                  default: 99
    t.string   "target_audience"
    t.string   "aasm_state",                  limit: 32
    t.boolean  "hide_contact_people",                     default: false
    t.boolean  "age_visible",                             default: false
    t.string   "code_word",                   limit: 140
    t.integer  "solution_category_id"
    t.string   "treatment_type"
    t.string   "participant_structure"
    t.string   "gender_first_part_of_stamp"
    t.string   "gender_second_part_of_stamp"
    t.integer  "logic_version_id"
    t.integer  "split_base_id"
    t.boolean  "all_inclusive",                           default: false
    t.date     "starts_at"
    t.datetime "completed_at"
    t.integer  "completed_by"
    t.string   "residency_status"
  end

  add_index "offers", ["aasm_state"], name: "index_offers_on_aasm_state"
  add_index "offers", ["approved_at"], name: "index_offers_on_approved_at"
  add_index "offers", ["area_id"], name: "index_offers_on_area_id"
  add_index "offers", ["created_at"], name: "index_offers_on_created_at"
  add_index "offers", ["location_id"], name: "index_offers_on_location_id"
  add_index "offers", ["logic_version_id"], name: "index_offers_on_logic_version_id"
  add_index "offers", ["solution_category_id"], name: "index_offers_on_solution_category_id"
  add_index "offers", ["split_base_id"], name: "index_offers_on_split_base_id"

  create_table "offers_openings", id: false, force: :cascade do |t|
    t.integer "offer_id",   null: false
    t.integer "opening_id", null: false
  end

  add_index "offers_openings", ["offer_id"], name: "index_offers_openings_on_offer_id"
  add_index "offers_openings", ["opening_id"], name: "index_offers_openings_on_opening_id"

  create_table "openings", force: :cascade do |t|
    t.string   "day",        limit: 3, null: false
    t.time     "open"
    t.time     "close"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_value"
    t.string   "name",                 null: false
  end

  add_index "openings", ["day"], name: "index_openings_on_day"
  add_index "openings", ["name"], name: "index_openings_on_name"

  create_table "organization_offers", force: :cascade do |t|
    t.integer "offer_id",        null: false
    t.integer "organization_id", null: false
  end

  add_index "organization_offers", ["offer_id"], name: "index_organization_offers_on_offer_id"
  add_index "organization_offers", ["organization_id"], name: "index_organization_offers_on_organization_id"

  create_table "organization_translations", force: :cascade do |t|
    t.integer  "organization_id",                   null: false
    t.string   "locale",                            null: false
    t.string   "source",            default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",       default: "",    null: false
    t.boolean  "possibly_outdated", default: false
  end

  add_index "organization_translations", ["locale"], name: "index_organization_translations_on_locale"
  add_index "organization_translations", ["organization_id"], name: "index_organization_translations_on_organization_id"

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                                                    null: false
    t.text     "description",                                             null: false
    t.string   "legal_form",                                              null: false
    t.boolean  "charitable",                         default: false
    t.integer  "founded"
    t.string   "slug"
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
    t.string   "mailings",               limit: 255, default: "disabled", null: false
    t.boolean  "priority",                           default: false,      null: false
  end

  add_index "organizations", ["aasm_state"], name: "index_organizations_on_aasm_state"
  add_index "organizations", ["approved_at"], name: "index_organizations_on_approved_at"
  add_index "organizations", ["created_at"], name: "index_organizations_on_created_at"

  create_table "search_locations", force: :cascade do |t|
    t.string   "query",                 null: false
    t.float    "latitude",              null: false
    t.float    "longitude",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "geoloc",     limit: 35, null: false
  end

  add_index "search_locations", ["geoloc"], name: "index_search_locations_on_geoloc"
  add_index "search_locations", ["query"], name: "index_search_locations_on_query"

  create_table "sitemaps", force: :cascade do |t|
    t.string "path",    null: false
    t.text   "content"
  end

  add_index "sitemaps", ["path"], name: "index_sitemaps_on_path", unique: true

  create_table "solution_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "parent_id"
  end

  create_table "solution_category_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "solution_category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "solution_category_anc_desc_idx", unique: true
  add_index "solution_category_hierarchies", ["descendant_id"], name: "solution_category_desc_idx"

  create_table "split_bases", force: :cascade do |t|
    t.string   "title",                null: false
    t.string   "clarat_addition"
    t.text     "comments"
    t.integer  "organization_id",      null: false
    t.integer  "solution_category_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "split_bases", ["organization_id"], name: "index_split_bases_on_organization_id"
  add_index "split_bases", ["solution_category_id"], name: "index_split_bases_on_solution_category_id"

  create_table "statistic_chart_goals", id: false, force: :cascade do |t|
    t.integer "statistic_chart_id", null: false
    t.integer "statistic_goal_id",  null: false
  end

  add_index "statistic_chart_goals", ["statistic_chart_id"], name: "index_statistic_chart_goals_on_statistic_chart_id"
  add_index "statistic_chart_goals", ["statistic_goal_id"], name: "index_statistic_chart_goals_on_statistic_goal_id"

  create_table "statistic_chart_transitions", id: false, force: :cascade do |t|
    t.integer "statistic_chart_id",      null: false
    t.integer "statistic_transition_id", null: false
  end

  add_index "statistic_chart_transitions", ["statistic_chart_id"], name: "index_statistic_chart_transitions_on_statistic_chart_id"
  add_index "statistic_chart_transitions", ["statistic_transition_id"], name: "index_statistic_chart_transitions_on_statistic_transition_id"

  create_table "statistic_charts", force: :cascade do |t|
    t.string  "title",        null: false
    t.date    "starts_at",    null: false
    t.date    "ends_at",      null: false
    t.integer "user_team_id"
    t.integer "user_id"
  end

  add_index "statistic_charts", ["user_id"], name: "index_statistic_charts_on_user_id"
  add_index "statistic_charts", ["user_team_id"], name: "index_statistic_charts_on_user_team_id"

  create_table "statistic_goals", force: :cascade do |t|
    t.integer "amount",    null: false
    t.date    "starts_at", null: false
  end

  create_table "statistic_transitions", force: :cascade do |t|
    t.string "klass_name",  null: false
    t.string "field_name",  null: false
    t.string "start_value", null: false
    t.string "end_value",   null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.string  "topic",             limit: 40
    t.integer "user_id"
    t.date    "date",                                           null: false
    t.float   "count",                        default: 0.0,     null: false
    t.integer "user_team_id"
    t.string  "model"
    t.string  "field_name"
    t.string  "field_start_value"
    t.string  "field_end_value"
    t.string  "time_frame",                   default: "daily"
  end

  add_index "statistics", ["user_id"], name: "index_statistics_on_user_id"
  add_index "statistics", ["user_team_id"], name: "index_statistics_on_user_team_id"

  create_table "subscriptions", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_allocations", force: :cascade do |t|
    t.integer "user_id",                     null: false
    t.integer "year",              limit: 4, null: false
    t.integer "week_number",       limit: 2, null: false
    t.integer "desired_wa_hours",  limit: 3, null: false
    t.integer "actual_wa_hours",   limit: 3
    t.string  "actual_wa_comment"
  end

  add_index "time_allocations", ["user_id"], name: "index_time_allocations_on_user_id"

  create_table "update_requests", force: :cascade do |t|
    t.string   "search_location", null: false
    t.string   "email",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_team_users", force: :cascade do |t|
    t.integer "user_team_id"
    t.integer "user_id"
  end

  add_index "user_team_users", ["user_id"], name: "index_user_team_users_on_user_id"
  add_index "user_team_users", ["user_team_id"], name: "index_user_team_users_on_user_team_id"

  create_table "user_teams", force: :cascade do |t|
    t.string "name",                                  null: false
    t.string "classification", default: "researcher"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "",         null: false
    t.string   "encrypted_password", default: "",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",               default: "standard"
    t.integer  "failed_attempts",    default: 0,          null: false
    t.datetime "locked_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.integer  "current_team_id"
  end

  add_index "users", ["current_team_id"], name: "index_users_on_current_team_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

  create_table "websites", force: :cascade do |t|
    t.string   "host",                          null: false
    t.string   "url",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unreachable_count", default: 0, null: false
  end

  add_index "websites", ["host"], name: "index_websites_on_host"
  add_index "websites", ["url"], name: "index_websites_on_url"

end
