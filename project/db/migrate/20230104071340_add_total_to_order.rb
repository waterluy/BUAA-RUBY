class AddTotalToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :total, :decimal
  end
end
