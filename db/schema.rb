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

ActiveRecord::Schema.define(version: 20151126040731) do

  create_table "cards", force: :cascade do |t|
    t.integer  "rank",       null: false
    t.integer  "suit",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer  "trump_card_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "games", ["trump_card_id"], name: "index_games_on_trump_card_id"

  create_table "players", force: :cascade do |t|
    t.integer  "game_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id"

  create_table "steps", force: :cascade do |t|
    t.integer  "kind",                   null: false
    t.integer  "player_id",              null: false
    t.integer  "card_id",                null: false
    t.integer  "in_response_to_step_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "steps", ["card_id"], name: "index_steps_on_card_id"
  add_index "steps", ["in_response_to_step_id"], name: "index_steps_on_in_response_to_step_id", unique: true
  add_index "steps", ["player_id"], name: "index_steps_on_player_id"

end
