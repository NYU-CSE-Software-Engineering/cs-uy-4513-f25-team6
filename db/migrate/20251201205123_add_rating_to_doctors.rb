class AddRatingToDoctors < ActiveRecord::Migration[8.1]
  def change
    add_column :doctors, :rating, :float
  end
end
