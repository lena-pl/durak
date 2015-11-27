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

  create_table "actions", force: :cascade do |t|
    t.integer  "kind"
    t.integer  "game_id"
    t.integer  "player_id"
    t.integer  "active_card_id"
    t.integer  "passive_card_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "actions", ["active_card_id"], name: "index_actions_on_active_card_id"
  add_index "actions", ["game_id"], name: "index_actions_on_game_id"
  add_index "actions", ["passive_card_id"], name: "index_actions_on_passive_card_id"
  add_index "actions", ["player_id"], name: "index_actions_on_player_id"

  create_table "cards", force: :cascade do |t|
    t.integer  "rank"
    t.integer  "suit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer  "trump_card_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "games", ["trump_card_id"], name: "index_games_on_trump_card_id"

  create_table "players", force: :cascade do |t|
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id"

end
