class CreateAdventureStateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :adventure_state_activities do |t|   # create tri join table with each id
      t.integer :adventure_id
      t.integer :state_id
      t.integer :activity_id
    end
  end
end
