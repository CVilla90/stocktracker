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

ActiveRecord::Schema[7.1].define(version: 2024_09_03_204358) do
  create_table "investment_portfolios", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investment_portfolios_stocks", force: :cascade do |t|
    t.integer "investment_portfolio_id", null: false
    t.integer "stock_id", null: false
    t.decimal "added_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1, null: false
    t.index ["investment_portfolio_id"], name: "index_investment_portfolios_stocks_on_investment_portfolio_id"
    t.index ["stock_id"], name: "index_investment_portfolios_stocks_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "investment_portfolios_stocks", "investment_portfolios"
  add_foreign_key "investment_portfolios_stocks", "stocks"
end
