class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|  # creates users table with keys
      t.string :username
      t.string :email
      t.string :password_digest
    end
  end
end
