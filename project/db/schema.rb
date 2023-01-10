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

ActiveRecord::Schema[7.0].define(version: 2023_01_05_031409) do
  create_table "cart_items", force: :cascade do |t|
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cart_id", null: false
    t.integer "product_id", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.index ["product_id"], name: "index_collects_on_product_id"
    t.index ["user_id"], name: "index_collects_on_user_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "product_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["product_id"], name: "index_comments_on_product_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "address"
    t.string "phone"
    t.string "post"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_id"
    t.integer "user_id", null: false
    t.decimal "total"
    t.integer "quantity"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image_url"
    t.integer "sales"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 8, scale: 2, default: "0.0"
    t.integer "category_id", null: false
    t.integer "color_id", null: false
    t.integer "size_id", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["color_id"], name: "index_products_on_color_id"
    t.index ["size_id"], name: "index_products_on_size_id"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "hashed_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "phone"
    t.string "email"
    t.string "post"
    t.text "description"
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "collects", "products"
  add_foreign_key "collects", "users"
  add_foreign_key "comments", "products"
  add_foreign_key "comments", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "colors"
  add_foreign_key "products", "sizes"
end
