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

ActiveRecord::Schema.define(version: 20160918181930) do

  create_table "academic_degree_term_courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "academic_degree_term_id"
    t.integer  "course_id"
    t.text     "groups",                  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["academic_degree_term_id", "course_id"], name: "academic_degree_terms_courses_index", unique: true, using: :btree
  end

  create_table "academic_degree_terms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "academic_degree_id"
    t.integer  "term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["academic_degree_id", "term_id"], name: "index_academic_degree_terms_on_academic_degree_id_and_term_id", unique: true, using: :btree
  end

  create_table "academic_degrees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_academic_degrees_on_code", unique: true, using: :btree
  end

  create_table "agenda_courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "academic_degree_term_course_id"
    t.integer  "agenda_id"
    t.boolean  "mandatory"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["academic_degree_term_course_id", "agenda_id"], name: "agenda_courses_index", unique: true, using: :btree
    t.index ["academic_degree_term_course_id"], name: "index_agenda_courses_on_academic_degree_term_course_id", using: :btree
    t.index ["agenda_id"], name: "index_agenda_courses_on_agenda_id", using: :btree
  end

  create_table "agendas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "academic_degree_term_id"
    t.string   "token"
    t.integer  "courses_per_schedule"
    t.text     "courses",                 limit: 65535
    t.text     "leaves",                  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "combined_at"
    t.boolean  "processing"
    t.text     "mandatory_course_ids",    limit: 65535
    t.index ["token"], name: "index_agendas_on_token", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "user_email"
    t.text   "body",       limit: 65535
  end

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_courses_on_code", unique: true, using: :btree
  end

  create_table "newsletter_subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email"
  end

  create_table "schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "agenda_id"
    t.text     "course_groups", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["agenda_id"], name: "index_schedules_on_agenda_id", using: :btree
  end

  create_table "terms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "year"
    t.string   "name"
    t.string   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "enabled_at"
    t.index ["year", "name", "tags"], name: "index_terms_on_year_and_name_and_tags", unique: true, using: :btree
  end

end
