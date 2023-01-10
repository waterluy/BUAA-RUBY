class CreateCollects < ActiveRecord::Migration[7.0]
  def change
    create_table :collects do |t|

      t.timestamps
    end
  end
end
