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

ActiveRecord::Schema.define(version: 20150919024745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "areas", primary_key: "area_id", force: :cascade do |t|
    t.string   "prefname"
    t.string   "area_type"
    t.text     "geom_poly_wkt"
    t.text     "geom_point_wkt"
    t.jsonb    "keywords"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "author_communities", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "community_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "author_communities", ["author_id", "community_id"], name: "index_author_communities_on_author_id_and_community_id", using: :btree

  create_table "author_forms", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "author_forms", ["author_id", "form_id"], name: "index_author_forms_on_author_id_and_form_id", using: :btree

  create_table "author_genres", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "author_genres", ["author_id", "genre_id"], name: "index_author_genres_on_author_id_and_genre_id", using: :btree

  create_table "author_standings", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "standing_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "author_standings", ["author_id", "standing_id"], name: "index_author_standings_on_author_id_and_standing_id", using: :btree

  create_table "authors", primary_key: "author_id", force: :cascade do |t|
    t.string   "prefname"
    t.string   "surname"
    t.string   "middle"
    t.string   "given"
    t.date     "birth_date"
    t.date     "death_date"
    t.integer  "birth_year"
    t.integer  "death_year"
    t.integer  "viaf_id"
    t.string   "wiki_id"
    t.integer  "categories", default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "authors_categories", force: :cascade do |t|
    t.integer "author_id"
    t.integer "category_id"
    t.integer "dimension_id"
  end

  add_index "authors_categories", ["author_id", "category_id"], name: "index_authors_categories_on_author_id_and_category_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "dim"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "communities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dimensions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forms", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "passages", primary_key: "passage_id", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "subject_id"
    t.text     "text"
    t.string   "placerefs",  default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "placerefs", force: :cascade do |t|
    t.integer  "placeref_id"
    t.integer  "work_id"
    t.string   "passage_id"
    t.string   "placeref"
    t.integer  "author_id"
    t.integer  "place_id"
    t.text     "geom_wkt"
    t.string   "placeref_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "places", force: :cascade do |t|
    t.integer  "place_id"
    t.string   "place_type"
    t.string   "names"
    t.string   "source"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "geom_wkt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standings", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "works", primary_key: "work_id", force: :cascade do |t|
    t.integer  "author_id"
    t.string   "title"
    t.integer  "work_year"
    t.integer  "categories", default: [],              array: true
    t.jsonb    "keywords"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
