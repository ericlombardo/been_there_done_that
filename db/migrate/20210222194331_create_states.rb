class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t| # create states table with keys
      t.string :name
      t.string :capital
      t.string :land_area
      t.string :state_forests
      t.string :state_parks
    end
  end
end
