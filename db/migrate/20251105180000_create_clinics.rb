class CreateClinics < ActiveRecord::Migration[8.0]
    def change
      create_table :clinics do |t|
        t.string :name
        t.string :specialty
        t.string :location
        t.float :rating
        t.timestamps
      end
      add_index :clinics, :name
    end
  end

