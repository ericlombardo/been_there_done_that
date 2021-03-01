class StateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :state_activities do |t|
      t.integer :state_id
      t.integer :activity_id
      t.integer :adventure_id
    end
  end
end
