class CreateTimeSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :time_slots do |t|
      t.belongs_to :doctor
      t.time :starts_at
      t.time :ends_at
      t.timestamps
    end
  end
end
