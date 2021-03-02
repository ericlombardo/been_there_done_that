class CreateTripStates < ActiveRecord::Migration[5.2]
  def change
    create_table :trip_states do |t|
      t.integer :trip_id
      t.integer :state_id
    end
  end
end
