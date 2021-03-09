class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t| # create activities table with keys
      t.string :name
      t.string :description
    end
  end
end
