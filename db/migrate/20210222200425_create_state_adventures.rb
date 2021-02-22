class CreateStateAdventures < ActiveRecord::Migration[5.2]
  def change
    create_table :state_adventures do |t|
      t.integer :state_id
      t.integer :adventure_id
    end
  end
end
