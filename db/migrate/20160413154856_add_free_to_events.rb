class AddFreeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :free, :boolean
  end
end
