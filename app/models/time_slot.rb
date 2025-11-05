class TimeSlot < ApplicationRecord
    belongs_to :doctor
    
    # all attributes must be present
    validates :doctor_id, :starts_at, :ends_at, presence: true
    # start must be before end
    validates :starts_at, comparison: {less_than: :ends_at}
    # start and end must both be within working hours
    validates :starts_at, comparison: {greater_than: Time.utc(2000,1,1,9)}
    validates :ends_at, comparison: {less_than: Time.utc(2000,1,1,17)}
    # no duplicate entries
    validates :starts_at, :ends_at, uniqueness: {scope: :doctor_id}
    # no overlapping entries
    validate :slots_cannot_overlap

    def slots_cannot_overlap
        TimeSlot.where(doctor_id: doctor_id).each do |existing|
            if starts_at >= existing.starts_at && starts_at <= existing.ends_at
                errors.add :starts_at, :overlaps_existing, message: "overlaps an existing time slot for doctor #{doctor_id}"
                break
            elsif ends_at >= existing.starts_at && ends_at <= existing.ends_at
                errors.add :ends_at, :overlaps_existing, message: "overlaps an existing time slot for doctor #{doctor_id}"
                break
            end
        end
    end
end