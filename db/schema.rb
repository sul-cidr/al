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

ActiveRecord::Schema.define(version: 20150715224345) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "attributes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "author_categories", force: :cascade do |t|
    t.integer  "auth_id"
    t.integer  "attribute_id"
    t.integer  "category_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "authors", force: :cascade do |t|
    t.integer  "auth_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "passages", force: :cascade do |t|
    t.string   "passage_id"
    t.text     "text"
    t.string   "placerefs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "placerefs", force: :cascade do |t|
    t.integer  "placeref_id"
    t.string   "prefname"
    t.integer  "place_id"
    t.string   "passage_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "places", force: :cascade do |t|
    t.integer  "place_id"
    t.string   "src"
    t.text     "geom_wkt"
    t.geometry "geom_mpoint", limit: {:srid=>4326, :type=>"multi_point"}
    t.geometry "geom_mpoly",  limit: {:srid=>4326, :type=>"multi_polygon"}
    t.geometry "geom_line",   limit: {:srid=>4326, :type=>"line_string"}
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  create_table "works", force: :cascade do |t|
    t.integer  "work_id"
    t.string   "title"
    t.integer  "auth_id"
    t.integer  "pub_year"
    t.integer  "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
