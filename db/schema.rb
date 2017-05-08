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

ActiveRecord::Schema.define(version: 20170427062028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "broadcasts", force: :cascade do |t|
    t.string   "email_id"
    t.string   "emails_subject"
    t.string   "meta_data"
    t.integer  "number_of_recipient"
    t.integer  "total_credit_consumed"
    t.string   "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["user_id", "email_id"], name: "index_broadcasts_on_user_id_and_email_id", unique: true, using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "emails", force: :cascade do |t|
    t.string   "template_id"
    t.string   "user"
    t.string   "subject"
    t.text     "body"
    t.integer  "state",          default: 0
    t.string   "public_id"
    t.string   "from_name"
    t.string   "from_address"
    t.string   "reply_address"
    t.datetime "scheduled_on"
    t.datetime "sent_on"
    t.jsonb    "recipients",     default: [], null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "template_count", default: 0
    t.jsonb    "links"
    t.index ["public_id"], name: "index_emails_on_public_id", unique: true, using: :btree
  end

  create_table "report_abuses", force: :cascade do |t|
    t.string   "email_id"
    t.string   "recipient_id"
    t.string   "reason"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
