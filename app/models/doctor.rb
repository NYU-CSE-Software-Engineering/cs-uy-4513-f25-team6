class Doctor < User
    belongs_to :clinic, optional: true
    has_many :time_slots
    has_many :appointments
end