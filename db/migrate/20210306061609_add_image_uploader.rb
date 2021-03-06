class AddImageUploader < ActiveRecord::Migration[5.2]
  def change
    add_column(:adventures, :image, :string)
  end
end
