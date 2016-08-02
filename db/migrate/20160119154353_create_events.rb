class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :time
      t.string :host
      t.string :desc
      t.string :people
      t.string :price

      t.timestamps null: false
    end
  end
end
