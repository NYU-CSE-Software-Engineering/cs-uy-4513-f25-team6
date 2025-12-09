class Appointment < ApplicationRecord
    belongs_to :patient
    belongs_to :time_slot
    has_one :doctor, through: :time_slot
    has_one :bill, dependent: :destroy
    # all attributes must be present
    validates :patient_id, :time_slot_id, :date, presence: true
    # each time slot can only be used once per day
    validates :time_slot_id, uniqueness: {scope: :date}

    after_create :create_bill

    def full_datetime
        Time.new(date.year, date.month, date.day, time_slot.starts_at.hour, time_slot.starts_at.min)
    end

    private

    def create_bill
        Bill.create!(
            appointment: self,
            amount: default_bill_amount,
            status: "unpaid",
            due_date: date + 7.days
        )
    end

    def default_bill_amount
        # Default bill amount - can be made configurable later
        100.0
    end

    def clinic_name
      doctor&.clinic&.name
    end
end