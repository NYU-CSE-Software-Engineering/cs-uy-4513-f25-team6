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

ActiveRecord::Schema[8.1].define(version: 2025_12_09_030427) do
  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.integer "patient_id"
    t.string "status"
    t.integer "time_slot_id"
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["time_slot_id"], name: "index_appointments_on_time_slot_id"
  end

  create_table "bills", force: :cascade do |t|
    t.decimal "amount"
    t.integer "appointment_id", null: false
    t.datetime "created_at", null: false
    t.date "due_date"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_bills_on_appointment_id"
  end

  create_table "clinics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.float "rating"
    t.string "specialty"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_clinics_on_name"
  end

  create_table "doctors", force: :cascade do |t|
    t.integer "clinic_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password"
    t.string "phone"
    t.float "rating"
    t.float "salary"
    t.string "specialty"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["clinic_id"], name: "index_doctors_on_clinic_id"
  end

  create_table "patients", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "gender"
    t.float "height"
    t.text "notes"
    t.string "password"
    t.datetime "updated_at", null: false
    t.string "username"
    t.float "weight"
  end

  create_table "time_slots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "doctor_id"
    t.time "ends_at"
    t.time "starts_at"
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_time_slots_on_doctor_id"
  end

  add_foreign_key "bills", "appointments"
end
