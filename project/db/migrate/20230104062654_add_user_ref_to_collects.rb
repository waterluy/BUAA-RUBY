class AddUserRefToCollects < ActiveRecord::Migration[7.0]
  def change
    add_reference :collects, :user, null: false, foreign_key: true
  end
end
