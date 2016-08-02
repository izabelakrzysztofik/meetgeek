class AddFieldsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :url, :string
    add_column :events, :adr, :string
    add_column :events, :date, :string
    
  end
end
