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

ActiveRecord::Schema.define(version: 20170509041523) do

  create_table "broadcasts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  create_table "buy_credits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code",                                                      null: false
    t.string   "name",                                                      null: false
    t.string   "description"
    t.integer  "credits",                                   default: 0,     null: false
    t.integer  "broadcasts"
    t.integer  "duration_in_days"
    t.boolean  "display",                                   default: true
    t.decimal  "price",            precision: 10, scale: 2, default: "0.0"
    t.integer  "minimum_members"
    t.integer  "maximum_members"
    t.boolean  "is_plan_for_team",                          default: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  create_table "country_currencies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "country"
    t.string   "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "priority",                 default: 0, null: false
    t.integer  "attempts",                 default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code",                                                       null: false
    t.string   "name",                                                       null: false
    t.string   "description"
    t.integer  "credits",                                    default: 0,     null: false
    t.integer  "broadcasts"
    t.integer  "duration_in_days"
    t.boolean  "display",                                    default: true
    t.decimal  "price",             precision: 10, scale: 2, default: "0.0"
    t.integer  "minimum_members"
    t.integer  "maximum_members"
    t.string   "stripe_id"
    t.boolean  "is_plan_for_team",                           default: false
    t.boolean  "is_auto_renewable",                          default: true
    t.string   "interval"
    t.integer  "interval_count",                             default: 1,     null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

end
