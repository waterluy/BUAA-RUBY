class Cart < ApplicationRecord
    belongs_to :user
    has_many :cart_items

    def add_item(product_id)
        current_item = cart_items.find_by_product_id(product_id)
        if (current_item)
            current_item.quantity += 1
        else
            current_item = cart_items.build(:product_id => product_id)
            current_item.quantity = 1
        end
        current_item
    end
end
