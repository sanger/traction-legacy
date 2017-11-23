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

ActiveRecord::Schema.define(version: 20171123165030) do

  create_table "aliquots", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flowcells", force: :cascade do |t|
    t.string "flowcell_id"
    t.integer "position"
    t.integer "sequencing_run_id"
    t.integer "work_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sequencing_run_id"], name: "index_flowcells_on_sequencing_run_id"
    t.index ["work_order_id"], name: "index_flowcells_on_work_order_id"
  end

  create_table "printers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sequencing_runs", force: :cascade do |t|
    t.string "instrument_name"
    t.integer "state", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "experiment_name"
  end

  create_table "tubes", force: :cascade do |t|
    t.string "barcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "work_orders", force: :cascade do |t|
    t.integer "state", default: 0
    t.string "sequencescape_id"
    t.string "study_uuid"
    t.string "sample_uuid"
    t.integer "aliquot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aliquot_id"], name: "index_work_orders_on_aliquot_id"
  end

end
