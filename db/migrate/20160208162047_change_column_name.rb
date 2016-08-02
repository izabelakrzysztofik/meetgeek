class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :events, :url, :event_url
  end
end
