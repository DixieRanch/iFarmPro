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

ActiveRecord::Schema.define(version: 20140614163846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocks", force: true do |t|
    t.string   "name"
    t.integer  "farm_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blocks", ["company_id"], name: "index_blocks_on_company_id", using: :btree
  add_index "blocks", ["farm_id"], name: "index_blocks_on_farm_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "current_ets", force: true do |t|
    t.integer  "doy"
    t.decimal  "fabian_garcia"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "current_ets", ["doy"], name: "index_current_ets_on_doy", using: :btree

  create_table "ets", force: true do |t|
    t.integer  "doy"
    t.decimal  "fabian_garcia"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "ets", ["doy"], name: "index_ets_on_doy", using: :btree

  create_table "farms", force: true do |t|
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "company_id"
    t.integer  "weather_station_id"
  end

  add_index "farms", ["company_id"], name: "index_farms_on_company_id", using: :btree
  add_index "farms", ["weather_station_id"], name: "index_farms_on_weather_station_id", using: :btree

  create_table "fields", force: true do |t|
    t.string   "name"
    t.decimal  "acreage"
    t.integer  "block_id"
    t.integer  "company_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "farm_id"
    t.integer  "soil_class_id"
  end

  add_index "fields", ["block_id"], name: "index_fields_on_block_id", using: :btree
  add_index "fields", ["company_id"], name: "index_fields_on_company_id", using: :btree
  add_index "fields", ["farm_id"], name: "index_fields_on_farm_id", using: :btree
  add_index "fields", ["soil_class_id"], name: "index_fields_on_soil_class_id", using: :btree

  create_table "irrigation_wells", force: true do |t|
    t.string   "name"
    t.string   "pod_code"
    t.integer  "farm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
  end

  add_index "irrigation_wells", ["company_id"], name: "index_irrigation_wells_on_company_id", using: :btree
  add_index "irrigation_wells", ["farm_id"], name: "index_irrigation_wells_on_farm_id", using: :btree

  create_table "irrigations", force: true do |t|
    t.datetime "time"
    t.integer  "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
    t.integer  "farm_id"
  end

  add_index "irrigations", ["company_id"], name: "index_irrigations_on_company_id", using: :btree
  add_index "irrigations", ["farm_id"], name: "index_irrigations_on_farm_id", using: :btree
  add_index "irrigations", ["field_id"], name: "index_irrigations_on_field_id", using: :btree

  create_table "kcs", force: true do |t|
    t.integer  "doy"
    t.decimal  "pecan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "kcs", ["doy"], name: "index_kcs_on_doy", using: :btree

  create_table "meter_readings", force: true do |t|
    t.integer  "irrigation_id"
    t.integer  "irrigation_well_id"
    t.integer  "company_id"
    t.integer  "start"
    t.integer  "stop"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "meter_readings", ["company_id"], name: "index_meter_readings_on_company_id", using: :btree
  add_index "meter_readings", ["irrigation_id"], name: "index_meter_readings_on_irrigation_id", using: :btree
  add_index "meter_readings", ["irrigation_well_id"], name: "index_meter_readings_on_irrigation_well_id", using: :btree

  create_table "rains", force: true do |t|
    t.date     "date"
    t.decimal  "amount"
    t.integer  "farm_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "soil_application_units", force: true do |t|
    t.string   "name"
    t.float    "density"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "soil_applications", force: true do |t|
    t.integer  "field_id"
    t.integer  "soil_product_id"
    t.float    "quantity"
    t.integer  "company_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.date     "date"
    t.integer  "soil_application_unit_id"
  end

  add_index "soil_applications", ["company_id"], name: "index_soil_applications_on_company_id", using: :btree
  add_index "soil_applications", ["field_id"], name: "index_soil_applications_on_field_id", using: :btree
  add_index "soil_applications", ["soil_product_id"], name: "index_soil_applications_on_soil_product_id", using: :btree

  create_table "soil_classes", force: true do |t|
    t.string   "name"
    t.decimal  "aw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "soil_products", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.integer  "n"
    t.integer  "p"
    t.integer  "k"
    t.integer  "s"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "company_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "weather_stations", force: true do |t|
    t.string   "name"
    t.string   "id_code"
    t.string   "db_col"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
