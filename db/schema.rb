# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_06_22_175452) do

  create_table "academic_degree_term_courses", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "academic_degree_term_id"
    t.integer "course_id"
    t.text "groups"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["academic_degree_term_id", "course_id"], name: "academic_degree_terms_courses_index", unique: true
  end

  create_table "academic_degree_terms", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "academic_degree_id"
    t.integer "term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["academic_degree_id", "term_id"], name: "index_academic_degree_terms_on_academic_degree_id_and_term_id", unique: true
  end

  create_table "academic_degrees", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_academic_degrees_on_code", unique: true
  end

  create_table "agenda_courses", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "academic_degree_term_course_id"
    t.integer "agenda_id"
    t.boolean "mandatory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "group_numbers"
    t.index ["academic_degree_term_course_id", "agenda_id"], name: "agenda_courses_index", unique: true
    t.index ["academic_degree_term_course_id"], name: "index_agenda_courses_on_academic_degree_term_course_id"
    t.index ["agenda_id"], name: "index_agenda_courses_on_agenda_id"
  end

  create_table "agendas", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "academic_degree_term_id"
    t.string "token"
    t.integer "courses_per_schedule"
    t.text "leaves"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "combined_at"
    t.boolean "processing"
    t.boolean "filter_groups"
    t.index ["token"], name: "index_agendas_on_token"
  end

  create_table "comments", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "user_email"
    t.text "body"
  end

  create_table "courses", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_courses_on_code", unique: true
  end

  create_table "mailkick_subscriptions", charset: "utf8", force: :cascade do |t|
    t.string "subscriber_type"
    t.bigint "subscriber_id"
    t.string "list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_type", "subscriber_id", "list"], name: "index_mailkick_subscriptions_on_subscriber_and_list", unique: true
  end

  create_table "schedules", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "agenda_id"
    t.text "course_groups"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["agenda_id"], name: "index_schedules_on_agenda_id"
  end

  create_table "terms", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "year"
    t.string "name"
    t.string "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "enabled_at"
    t.index ["year", "name", "tags"], name: "index_terms_on_year_and_name_and_tags", unique: true
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
