class CreateAdventures < ActiveRecord::Migration[5.2]
  def change
    create_table :adventures do |t|
      t.string :title
      t.integer :rating
      t.boolean :recommend
      t.date :start_date
      t.date :end_date
      t.integer :miles_covered
      t.string :companions
      t.text :highlight
      t.string :weather
      t.text :summary
      t.string :transportation
      t.string :food
      t.text :private_notes

      t.integer :user_id
    end
  end
end
