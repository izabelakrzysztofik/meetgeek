class AddStartDateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :start_date, :date
    add_index :events, :start_date
  end
end
