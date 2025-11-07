class CreateAppointments < ActiveRecord::Migration[8.0]
    def change
      create_table :appointments do |t|
        t.belongs_to :patient
        t.belongs_to :time_slot
        t.date :date
        t.timestamps
      end
    end
  end
