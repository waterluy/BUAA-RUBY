class AddCartRefToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :cart_items, :cart, null: false, foreign_key: true
  end
end
