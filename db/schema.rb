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

ActiveRecord::Schema.define(version: 20180506142423) do

  create_table "engine_task_exceptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "engine_task_id", null: false
    t.integer "line"
    t.string "exception_class", null: false
    t.text "file"
    t.string "snapshot_file"
    t.string "html_file"
    t.text "extra_message"
    t.text "message"
    t.text "stack_trace_as_json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["engine_task_id"], name: "index_engine_task_exceptions_on_engine_task_id"
    t.index ["exception_class"], name: "index_engine_task_exceptions_on_exception_class", length: { exception_class: 80 }
    t.index ["file"], name: "index_engine_task_exceptions_on_file", length: { file: 200 }
    t.index ["line"], name: "index_engine_task_exceptions_on_line"
  end

  create_table "engine_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "engine", null: false
    t.string "task"
    t.boolean "is_started", default: false, null: false
    t.boolean "is_stopped", default: false, null: false
    t.boolean "is_error", default: false, null: false
    t.datetime "start"
    t.datetime "stop"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flancer_freelancer_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer "internal_id"
    t.boolean "is_read", default: false, null: false
    t.string "star_color"
    t.text "link", null: false
    t.string "star_symbol"
    t.text "price_hint"
    t.text "number_bids"
    t.text "title"
    t.text "description"
    t.text "tags"
    t.text "status"
    t.text "when_posted"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["internal_id"], name: "index_flancer_freelancer_jobs_on_internal_id", unique: true
    t.index ["is_read"], name: "index_flancer_freelancer_jobs_on_is_read"
    t.index ["link"], name: "index_flancer_freelancer_jobs_on_link", unique: true, length: { link: 210 }
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "role", default: "user", null: false
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  create_table "x_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "engine_task_id"
    t.boolean "is_read", default: false, null: false
    t.string "star_color"
    t.string "star_symbol"
    t.string "internal_id", null: false
    t.text "link"
    t.string "engine"
    t.text "price_hint"
    t.text "title"
    t.text "description"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["engine_task_id"], name: "index_x_jobs_on_engine_task_id"
    t.index ["internal_id"], name: "index_x_jobs_on_internal_id", unique: true, length: { internal_id: 20 }
    t.index ["is_read"], name: "index_x_jobs_on_is_read"
    t.index ["link"], name: "index_x_jobs_on_link", unique: true, length: { link: 210 }
    t.index ["star_color"], name: "index_x_jobs_on_star_color"
    t.index ["star_symbol"], name: "index_x_jobs_on_star_symbol", length: { star_symbol: 4 }
  end

  add_foreign_key "engine_task_exceptions", "engine_tasks", name: "eeei_exceptions_has_engine_task_fk"
  add_foreign_key "x_jobs", "engine_tasks", name: "xjob_has_engine_task_fk"
end
