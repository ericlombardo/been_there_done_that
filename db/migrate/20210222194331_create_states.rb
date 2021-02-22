class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :name
      t.string :capital
      t.string :motto
      t.string :land_area
      t.string :state_forests
      t.string :state_parks_and_rec_areas
    end
  end
end
