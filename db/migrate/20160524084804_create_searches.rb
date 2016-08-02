class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :tags
      t.string :category
      t.string :price
      t.datetime :start_date
      t.string :address

      t.timestamps null: false
    end
  end
end
