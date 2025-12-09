class Appointment < ApplicationRecord
    belongs_to :patient
    belongs_to :time_slot
    has_one :doctor, through: :time_slot

    # all attributes must be present
    validates :patient_id, :time_slot_id, :date, presence: true
    # each time slot can only be used once per day
    validates :time_slot_id, uniqueness: {scope: :date}

    def full_datetime
        Time.new(date.year, date.month, date.day, time_slot.starts_at.hour, time_slot.starts_at.min)
    end

    def clinic_name
      doctor&.clinic&.name
    end
end