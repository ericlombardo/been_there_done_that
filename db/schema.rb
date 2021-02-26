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

ActiveRecord::Schema.define(version: 2021_02_22_200425) do

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "adventure_activities", force: :cascade do |t|
    t.integer "adventure_id"
    t.integer "activity_id"
  end

  create_table "adventures", force: :cascade do |t|
    t.string "title"
    t.integer "rating"
    t.boolean "recommend"
    t.string "start_date"
    t.string "end_date"
    t.float "miles_covered"
    t.string "companions"
    t.text "highlight"
    t.string "weather"
    t.text "summary"
    t.string "transportation"
    t.string "food"
    t.text "private_notes"
    t.integer "user_id"
  end

  create_table "state_activities", force: :cascade do |t|
    t.integer "state_id"
    t.integer "activity_id"
  end

  create_table "state_adventures", force: :cascade do |t|
    t.integer "state_id"
    t.integer "adventure_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "capital"
    t.string "land_area"
    t.string "state_forests"
    t.string "state_parks"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
  end

end
