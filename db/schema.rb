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

ActiveRecord::Schema.define(version: 20170802094621) do

  create_table "absences", force: :cascade do |t|
    t.date "starts_at", null: false
    t.date "ends_at", null: false
    t.integer "user_id", null: false
    t.boolean "sync", default: true
    t.index ["user_id"], name: "index_absences_on_user_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "name", null: false
    t.float "minlat", null: false
    t.float "maxlat", null: false
    t.float "minlong", null: false
    t.float "maxlong", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: :cascade do |t|
    t.integer "assignable_id", null: false
    t.string "assignable_type", limit: 32, null: false
    t.string "assignable_field_type", limit: 64, default: "", null: false
    t.integer "creator_id"
    t.integer "creator_team_id"
    t.integer "receiver_id"
    t.integer "receiver_team_id"
    t.string "message", limit: 1000
    t.integer "parent_id"
    t.string "aasm_state", limit: 32, default: "open", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "topic"
    t.boolean "created_by_system", default: false
    t.index ["aasm_state"], name: "index_assignments_on_aasm_state"
    t.index ["assignable_id", "assignable_type"], name: "index_assignments_on_assignable_id_and_assignable_type"
    t.index ["creator_id"], name: "index_assignments_on_creator_id"
    t.index ["creator_team_id"], name: "index_assignments_on_creator_team_id"
    t.index ["parent_id"], name: "index_assignments_on_parent_id"
    t.index ["receiver_id"], name: "index_assignments_on_receiver_id"
    t.index ["receiver_team_id"], name: "index_assignments_on_receiver_team_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name_de", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "icon", limit: 12
    t.integer "parent_id"
    t.integer "sort_order"
    t.boolean "visible", default: true
    t.string "name_en"
    t.string "name_ar"
    t.string "name_fr"
    t.string "name_pl"
    t.string "name_tr"
    t.string "name_ru"
    t.string "name_fa"
    t.text "keywords_de"
    t.text "keywords_en"
    t.text "keywords_ar"
    t.text "keywords_fa"
    t.text "explanations_de"
    t.text "explanations_en"
    t.text "explanations_ar"
    t.text "explanations_fa"
    t.index ["name_de"], name: "index_categories_on_name_de"
  end

  create_table "categories_filters", id: false, force: :cascade do |t|
    t.integer "filter_id", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_filters_categories_on_category_id"
    t.index ["filter_id"], name: "index_filters_categories_on_filter_id"
  end

  create_table "categories_offers", id: false, force: :cascade do |t|
    t.integer "offer_id", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_categories_offers_on_category_id"
    t.index ["offer_id"], name: "index_categories_offers_on_offer_id"
  end

  create_table "categories_sections", force: :cascade do |t|
    t.integer "category_id"
    t.integer "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categories_sections_on_category_id"
    t.index ["section_id"], name: "index_categories_sections_on_section_id"
  end

  create_table "category_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "category_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "category_desc_idx"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_people", force: :cascade do |t|
    t.integer "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "area_code_1", limit: 6
    t.string "local_number_1", limit: 32
    t.string "area_code_2", limit: 6
    t.string "local_number_2", limit: 32
    t.string "fax_area_code", limit: 6
    t.string "fax_number", limit: 32
    t.string "first_name"
    t.string "last_name"
    t.string "operational_name"
    t.string "academic_title"
    t.string "gender"
    t.string "responsibility"
    t.integer "email_id"
    t.boolean "spoc", default: false, null: false
    t.string "position"
    t.string "street", limit: 255
    t.string "zip_and_city", limit: 255
    t.index ["email_id"], name: "index_contact_people_on_email_id"
    t.index ["organization_id"], name: "index_contact_people_on_organization_id"
  end

  create_table "contact_person_offers", force: :cascade do |t|
    t.integer "offer_id", null: false
    t.integer "contact_person_id", null: false
    t.index ["contact_person_id"], name: "index_contact_person_offers_on_contact_person_id"
    t.index ["offer_id"], name: "index_contact_person_offers_on_offer_id"
  end

  create_table "contact_person_translations", force: :cascade do |t|
    t.integer "contact_person_id", null: false
    t.string "locale", null: false
    t.string "source", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "responsibility"
    t.index ["contact_person_id"], name: "index_contact_person_translations_on_contact_person_id"
    t.index ["locale"], name: "index_contact_person_translations_on_locale"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "message"
    t.string "url", limit: 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "internal_mail", default: false
    t.string "city"
  end

  create_table "definitions", force: :cascade do |t|
    t.text "key", limit: 400, null: false
    t.text "explanation", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "definitions_offers", force: :cascade do |t|
    t.integer "definition_id", null: false
    t.integer "offer_id", null: false
    t.index ["definition_id"], name: "index_definitions_offers_on_definition_id"
    t.index ["offer_id"], name: "index_definitions_offers_on_offer_id"
  end

  create_table "definitions_organizations", force: :cascade do |t|
    t.integer "definition_id", null: false
    t.integer "organization_id", null: false
    t.index ["definition_id"], name: "index_definitions_organizations_on_definition_id"
    t.index ["organization_id"], name: "index_definitions_organizations_on_organization_id"
  end

  create_table "divisions", force: :cascade do |t|
    t.string "addition"
    t.integer "organization_id"
    t.integer "section_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.boolean "done", default: false
    t.string "size", default: "medium", null: false
    t.integer "city_id"
    t.integer "area_id"
    t.index ["area_id"], name: "index_divisions_on_area_id"
    t.index ["city_id"], name: "index_divisions_on_city_id"
    t.index ["organization_id"], name: "index_divisions_on_organization_id"
    t.index ["section_id"], name: "index_divisions_on_section_id"
  end

  create_table "divisions_presumed_categories", id: false, force: :cascade do |t|
    t.integer "division_id", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_divisions_presumed_categories_on_category_id"
    t.index ["division_id"], name: "index_divisions_presumed_categories_on_division_id"
  end

  create_table "divisions_presumed_solution_categories", id: false, force: :cascade do |t|
    t.integer "division_id", null: false
    t.integer "solution_category_id", null: false
    t.index ["division_id"], name: "index_divisions_presumed_solution_categories_on_division_id"
    t.index ["solution_category_id"], name: "index_presumed_s_categories_on_s_category"
  end

  create_table "emails", force: :cascade do |t|
    t.string "address", limit: 64, null: false
    t.string "aasm_state", limit: 32, default: "uninformed", null: false
    t.string "security_code", limit: 36
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "federal_states", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filters", force: :cascade do |t|
    t.string "name", null: false
    t.string "identifier", limit: 35, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "type", null: false
    t.integer "section_id"
    t.index ["section_id"], name: "index_filters_on_section_id"
  end

  create_table "filters_offers", id: false, force: :cascade do |t|
    t.integer "filter_id", null: false
    t.integer "offer_id", null: false
    t.index ["filter_id"], name: "index_filters_offers_on_filter_id"
    t.index ["offer_id"], name: "index_filters_offers_on_offer_id"
  end

  create_table "filters_organizations", id: false, force: :cascade do |t|
    t.integer "filter_id", null: false
    t.integer "organization_id", null: false
    t.index ["filter_id"], name: "index_filters_organizations_on_filter_id"
    t.index ["organization_id"], name: "index_filters_organizations_on_organization_id"
  end

  create_table "gengo_orders", force: :cascade do |t|
    t.integer "order_id"
    t.string "expected_slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hyperlinks", force: :cascade do |t|
    t.integer "linkable_id", null: false
    t.string "linkable_type", limit: 40, null: false
    t.integer "website_id", null: false
    t.index ["linkable_id", "linkable_type"], name: "index_hyperlinks_on_linkable_id_and_linkable_type"
    t.index ["website_id"], name: "index_hyperlinks_on_website_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "street", null: false
    t.text "addition"
    t.string "zip", null: false
    t.boolean "hq"
    t.float "latitude"
    t.float "longitude"
    t.integer "organization_id"
    t.integer "federal_state_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "display_name", null: false
    t.boolean "visible", default: true
    t.boolean "in_germany", default: true
    t.integer "city_id"
    t.index ["city_id"], name: "index_locations_on_city_id"
    t.index ["created_at"], name: "index_locations_on_created_at"
    t.index ["federal_state_id"], name: "index_locations_on_federal_state_id"
    t.index ["organization_id"], name: "index_locations_on_organization_id"
  end

  create_table "logic_versions", force: :cascade do |t|
    t.integer "version"
    t.string "name"
    t.text "description"
  end

  create_table "next_steps", force: :cascade do |t|
    t.string "text_de", null: false
    t.string "text_en"
    t.string "text_ar"
    t.string "text_fr"
    t.string "text_pl"
    t.string "text_tr"
    t.string "text_ru"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "text_fa"
    t.index ["text_de"], name: "index_next_steps_on_text_de"
  end

  create_table "next_steps_offers", force: :cascade do |t|
    t.integer "next_step_id", null: false
    t.integer "offer_id", null: false
    t.integer "sort_value", default: 0
    t.index ["next_step_id"], name: "index_next_steps_offers_on_next_step_id"
    t.index ["offer_id"], name: "index_organization_translations_on_offer_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "text", null: false
    t.string "topic", limit: 32
    t.integer "user_id", null: false
    t.integer "notable_id", null: false
    t.string "notable_type", limit: 64, null: false
    t.integer "referencable_id"
    t.string "referencable_type", limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["notable_id", "notable_type"], name: "index_notes_on_notable_id_and_notable_type"
    t.index ["referencable_id", "referencable_type"], name: "index_notes_on_referencable_id_and_referencable_type"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "offer_mailings", force: :cascade do |t|
    t.integer "offer_id", null: false
    t.integer "email_id", null: false
    t.string "mailing_type", limit: 16, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email_id"], name: "index_offer_mailings_on_email_id"
    t.index ["offer_id"], name: "index_offer_mailings_on_offer_id"
  end

  create_table "offer_translations", force: :cascade do |t|
    t.integer "offer_id", null: false
    t.string "locale", null: false
    t.string "source", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255, default: "", null: false
    t.text "description", default: "", null: false
    t.text "old_next_steps"
    t.text "opening_specification"
    t.boolean "possibly_outdated", default: false
    t.index ["locale"], name: "index_offer_translations_on_locale"
    t.index ["offer_id"], name: "index_offer_translations_on_offer_id"
  end

  create_table "offers", force: :cascade do |t|
    t.string "name", limit: 120, null: false
    t.text "description", null: false
    t.text "old_next_steps"
    t.string "encounter"
    t.string "slug"
    t.integer "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "opening_specification"
    t.datetime "approved_at"
    t.integer "created_by"
    t.integer "approved_by"
    t.date "expires_at", null: false
    t.integer "area_id"
    t.text "description_html"
    t.text "next_steps_html"
    t.text "opening_specification_html"
    t.string "target_audience"
    t.string "aasm_state", limit: 32
    t.boolean "hide_contact_people", default: false
    t.string "code_word", limit: 140
    t.integer "solution_category_id"
    t.integer "logic_version_id"
    t.integer "split_base_id"
    t.boolean "all_inclusive", default: false
    t.date "starts_at"
    t.datetime "completed_at"
    t.integer "completed_by"
    t.integer "section_id"
    t.index ["aasm_state"], name: "index_offers_on_aasm_state"
    t.index ["approved_at"], name: "index_offers_on_approved_at"
    t.index ["area_id"], name: "index_offers_on_area_id"
    t.index ["created_at"], name: "index_offers_on_created_at"
    t.index ["location_id"], name: "index_offers_on_location_id"
    t.index ["logic_version_id"], name: "index_offers_on_logic_version_id"
    t.index ["section_id"], name: "index_offers_on_section_id"
    t.index ["solution_category_id"], name: "index_offers_on_solution_category_id"
    t.index ["split_base_id"], name: "index_offers_on_split_base_id"
  end

  create_table "offers_openings", id: false, force: :cascade do |t|
    t.integer "offer_id", null: false
    t.integer "opening_id", null: false
    t.index ["offer_id"], name: "index_offers_openings_on_offer_id"
    t.index ["opening_id"], name: "index_offers_openings_on_opening_id"
  end

  create_table "openings", force: :cascade do |t|
    t.string "day", limit: 3, null: false
    t.time "open"
    t.time "close"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "sort_value"
    t.string "name", null: false
    t.index ["day"], name: "index_openings_on_day"
    t.index ["name"], name: "index_openings_on_name"
  end

  create_table "organization_offers", force: :cascade do |t|
    t.integer "offer_id", null: false
    t.integer "organization_id", null: false
    t.index ["offer_id"], name: "index_organization_offers_on_offer_id"
    t.index ["organization_id"], name: "index_organization_offers_on_organization_id"
  end

  create_table "organization_translations", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "locale", null: false
    t.string "source", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description", default: "", null: false
    t.boolean "possibly_outdated", default: false
    t.index ["locale"], name: "index_organization_translations_on_locale"
    t.index ["organization_id"], name: "index_organization_translations_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "legal_form"
    t.boolean "charitable", default: false
    t.integer "founded"
    t.string "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "approved_at"
    t.integer "offers_count", default: 0
    t.integer "locations_count", default: 0
    t.integer "created_by"
    t.integer "approved_by"
    t.boolean "accredited_institution", default: false
    t.text "description_html"
    t.string "aasm_state", limit: 32
    t.string "mailings", limit: 255, default: "disabled", null: false
    t.boolean "priority", default: false, null: false
    t.text "comment"
    t.integer "website_id"
    t.string "pending_reason"
    t.index ["aasm_state"], name: "index_organizations_on_aasm_state"
    t.index ["approved_at"], name: "index_organizations_on_approved_at"
    t.index ["created_at"], name: "index_organizations_on_created_at"
    t.index ["website_id"], name: "index_organizations_on_website_id"
  end

  create_table "search_locations", force: :cascade do |t|
    t.string "query", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "geoloc", limit: 35, null: false
    t.index ["geoloc"], name: "index_search_locations_on_geoloc"
    t.index ["query"], name: "index_search_locations_on_query"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sitemaps", force: :cascade do |t|
    t.string "path", null: false
    t.text "content"
    t.index ["path"], name: "index_sitemaps_on_path", unique: true
  end

  create_table "solution_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
  end

  create_table "solution_category_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "solution_category_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "solution_category_desc_idx"
  end

  create_table "split_base_divisions", force: :cascade do |t|
    t.integer "split_base_id", null: false
    t.integer "division_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["division_id"], name: "index_split_base_divisions_on_division_id"
    t.index ["split_base_id"], name: "index_split_base_divisions_on_split_base_id"
  end

  create_table "split_bases", force: :cascade do |t|
    t.string "title", null: false
    t.string "clarat_addition"
    t.text "comments"
    t.integer "organization_id"
    t.integer "solution_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_split_bases_on_organization_id"
    t.index ["solution_category_id"], name: "index_split_bases_on_solution_category_id"
  end

  create_table "statistic_chart_goals", id: false, force: :cascade do |t|
    t.integer "statistic_chart_id", null: false
    t.integer "statistic_goal_id", null: false
    t.index ["statistic_chart_id"], name: "index_statistic_chart_goals_on_statistic_chart_id"
    t.index ["statistic_goal_id"], name: "index_statistic_chart_goals_on_statistic_goal_id"
  end

  create_table "statistic_chart_transitions", id: false, force: :cascade do |t|
    t.integer "statistic_chart_id", null: false
    t.integer "statistic_transition_id", null: false
    t.index ["statistic_chart_id"], name: "index_statistic_chart_transitions_on_statistic_chart_id"
    t.index ["statistic_transition_id"], name: "index_statistic_chart_transitions_on_statistic_transition_id"
  end

  create_table "statistic_charts", force: :cascade do |t|
    t.string "title", null: false
    t.date "starts_at", null: false
    t.date "ends_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_statistic_charts_on_user_id"
  end

  create_table "statistic_goals", force: :cascade do |t|
    t.integer "amount", null: false
    t.date "starts_at", null: false
  end

  create_table "statistic_transitions", force: :cascade do |t|
    t.string "klass_name", null: false
    t.string "field_name", null: false
    t.string "start_value", null: false
    t.string "end_value", null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.string "topic", limit: 40
    t.date "date", null: false
    t.float "count", default: 0.0, null: false
    t.string "model"
    t.string "field_name"
    t.string "field_start_value"
    t.string "field_end_value"
    t.string "time_frame", default: "daily"
    t.string "trackable_type"
    t.integer "trackable_id"
    t.index ["trackable_id", "trackable_type"], name: "index_statistics_on_trackable_id_and_trackable_type"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name_de"
    t.text "keywords_de"
    t.text "keywords_en"
    t.text "keywords_ar"
    t.text "keywords_fa"
    t.string "name_en"
    t.string "name_fr"
    t.string "name_pl"
    t.string "name_ru"
    t.string "name_ar"
    t.string "name_fa"
    t.string "name_tr"
    t.text "explanations_de"
    t.text "explanations_en"
    t.text "explanations_ar"
    t.text "explanations_fa"
  end

  create_table "tags_offers", id: false, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "offer_id", null: false
    t.index ["offer_id"], name: "index_tags_offers_on_offer_id"
    t.index ["tag_id"], name: "index_tags_offers_on_tag_id"
  end

  create_table "target_audience_filters_offers", force: :cascade do |t|
    t.integer "target_audience_filter_id", null: false
    t.integer "offer_id", null: false
    t.string "residency_status"
    t.string "gender_first_part_of_stamp"
    t.string "gender_second_part_of_stamp"
    t.integer "age_from", default: 0, null: false
    t.integer "age_to", default: 99, null: false
    t.boolean "age_visible", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "stamp_de"
    t.string "stamp_en"
    t.string "stamp_ar"
    t.string "stamp_fa"
    t.string "stamp_fr"
    t.string "stamp_tr"
    t.string "stamp_ru"
    t.string "stamp_pl"
    t.index ["offer_id"], name: "index_target_audience_filters_offers_on_offer_id"
    t.index ["target_audience_filter_id"], name: "index_ta_filters_offers_on_target_audience_filter_id"
  end

  create_table "time_allocations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "year", limit: 4, null: false
    t.integer "week_number", limit: 2, null: false
    t.integer "desired_wa_hours", limit: 3, null: false
    t.integer "actual_wa_hours", limit: 3
    t.string "actual_wa_comment"
    t.index ["user_id"], name: "index_time_allocations_on_user_id"
  end

  create_table "update_requests", force: :cascade do |t|
    t.string "search_location", null: false
    t.string "email", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_team_observing_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "user_team_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_user_team_observing_users_on_user_id"
    t.index ["user_team_id"], name: "index_user_team_observing_users_on_user_team_id"
  end

  create_table "user_team_users", force: :cascade do |t|
    t.integer "user_team_id"
    t.integer "user_id"
    t.index ["user_id"], name: "index_user_team_users_on_user_id"
    t.index ["user_team_id"], name: "index_user_team_users_on_user_team_id"
  end

  create_table "user_teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "classification", default: "researcher"
    t.integer "lead_id"
    t.integer "parent_id"
    t.index ["lead_id"], name: "index_user_teams_on_lead_id"
    t.index ["parent_id"], name: "index_user_teams_on_parent_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "role", default: "standard"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.boolean "active", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "websites", force: :cascade do |t|
    t.string "host", null: false
    t.string "url", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "unreachable_count", default: 0, null: false
    t.boolean "ignored_by_crawler", default: false
    t.index ["host"], name: "index_websites_on_host"
    t.index ["url"], name: "index_websites_on_url"
  end

end
