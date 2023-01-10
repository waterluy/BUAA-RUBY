class AddItemIdToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :item_id, :integer
  end
end
